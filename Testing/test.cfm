<cffunction name="deleteModuleObjectContact" access="public" output="false" returntype="void" hint="Delete Module Role">
    <cfargument name="objectId" type="string" required="true" hint="Object Id" />
    <cfargument name="id" type="numeric" required="true" hint="ID" />

    <!--- Fetch details from ModuleObjectContacts --->
    <cfquery name="qDetails" datasource="#variables.dbSource#">
        SELECT moduleroleid, contacttype, objectid, contactid
        FROM security.ModuleObjectContacts
        WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>

    <!--- Ensure qDetails returned data before proceeding --->
    <cfif qDetails.recordCount EQ 0>
        <cfthrow message="No record found for the given ID: #arguments.id#">
    </cfif>

    <!--- Fetch permissions based on moduleroleid and objectId --->
    <cfquery name="variables.getPermissions" datasource="#variables.dbSource#">
        SELECT rolepermissions, securityObjects.objectTypeId
        FROM security.moduleRolepermissions 
        INNER JOIN securityObjects ON security.moduleRolepermissions.objectType = securityObjects.objectTypeId
        WHERE moduleRoleid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qDetails.moduleroleid#">
        AND securityObjects.objectid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qDetails.objectId#">
    </cfquery>

    <!--- Initialize permissionData structure --->
    <cfset permissionData = structNew()>

    <!--- Assign roleId or userId based on contactType --->
    <cfif qDetails.contacttype EQ "group">
        <cfset permissionData['roleId'] = qDetails.contactid>
    <cfelse>
        <cfset permissionData['userId'] = qDetails.contactid>
    </cfif>

    <!--- Process role permissions --->
    <cfloop list="#variables.getPermissions.rolepermissions#" index="variables.rolePermission">
        <cfif right(variables.rolePermission, 1) EQ "x">
            <cfset permissionName = left(variables.rolePermission, len(variables.rolePermission) - 1)>
            <cfset permissionData[permissionName] = "Block">
        <cfelse>
            <cfset permissionData[variables.rolePermission] = "Allow">
        </cfif>
    </cfloop>

    <!--- Debugging (Remove after confirming) --->
    <cfdump var="#permissionData#">
    <cfabort>

    <!--- Check if the permission record exists before deleting --->
    <cfif variables.getPermissions.recordCount GT 0>
        <cfif variables.getPermissions.objectTypeId EQ arguments.objectId>
            <!--- Not inherited, so delete record --->
            <cfquery datasource="#variables.dbSource#">
                DELETE FROM security.ModuleObjectContacts
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
            </cfquery>

            <!--- Delete role or user permission --->
            <cfif qDetails.contacttype EQ "group">
                <cfset new cfcs.security.RolePermissions(Session.DBSource).deleteRolePermissionEntry(qDetails.objectid, permissionData)>
            <cfelse>
                <cfset new cfcs.security.userPermission(Session.DBSource).deleteUserPermission(qDetails.objectid, permissionData)>
            </cfif>
        <cfelse>
            <!--- Inherited permissions, update permissions instead of deleting --->
            <cfif qDetails.contacttype EQ "group">
                <cfset rolePermissionData = ArrayNew(1)>
                <cfset arrayAppend(rolePermissionData, permissionData)>
                <cfset new cfcs.Security.RolePermissions().saveRolePermissionEntry(arguments.objectId, rolePermissionData)>
            <cfelse>
                <cfset userPermissionData = ArrayNew(1)>
                <cfset arrayAppend(userPermissionData, permissionData)>
                <cfset new cfcs.security.userPermission(Session.DBSource).saveUserPermission(arguments.objectId, userPermissionData)>
            </cfif>

            <!--- Send cache update message --->
            <cfset q = CreateObject("component", "Queue.MessageQueue").init(datasource=session.dbsource, logFile='messageQueue')>
            <cfset q.sendMessage('SecurityCacheHandler', {"ObjectID"=arguments.ObjectId}, session.UnitId)>
        </cfif>
    </cfif>

    <cfreturn true>
</cffunction>
