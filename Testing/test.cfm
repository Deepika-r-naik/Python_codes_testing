<cffunction name = "deleteModuleObjectContact" access="public" output="false" returntype="void" hint="Delete Module Role">
        <cfargument name="objectId" type="string" required="true" hint="Object Id" />
        <cfargument name="id" type="numeric" required="true" hint="ID" />

        <cfquery name="variables.getPermissions" datasource="#variables.dbSource#">
            SELECT moc.moduleroleid, moc.contacttype, moc.objectid, moc.contactid, 
                   mrp.rolepermissions, so.objectTypeId
            FROM security.ModuleObjectContacts moc
            Inner JOIN security.moduleRolepermissions mrp ON moc.moduleroleid = mrp.moduleRoleid
            Inner JOIN securityObjects so ON mrp.objectType = so.objectTypeId
            WHERE moc.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.id#">
            AND so.objectid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#moc.objectId#">
        </cfquery>
    
        <cfset permissionData = structNew()>
        <cfif variables.getPermissions.contacttype EQ "group">
            <cfset permissionData['roleId'] = variables.getPermissions.contactid>
        <cfelse>
            <cfset permissionData['userId'] = variables.getPermissions.contactid>
        </cfif>
        <cfloop list="#variables.getPermissions.rolepermissions#" index="variables.rolePermission">
            <cfif right(variables.rolePermission,1) EQ "x">
                <cfset permissionName = left(variables.rolePermission,len(variables.rolePermission)-1)>
                <cfset permissionData[#permissionName#] = "Block">
            <cfelse>
                <cfset permissionData[#variables.rolePermission#] = "Allow">
            </cfif>
        </cfloop>
    <cfdump var = "#permissionData#">
    <cfabort>
       <!--- <cfif variables.getPermissions.recordCount GT 0>
            <cfif variables.getPermissions.objectTypeId EQ arguments.objectId>
                
                <cfset isInherited = false>
                <cfquery datasource="#variables.dbSource#">
                    DELETE FROM security.ModuleObjectContacts
                    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
                </cfquery>
                <cfif variables.getPermissions.contacttype EQ "group">
                    <cfset new cfcs.security.RolePermissions(Session.DBSource).deleteRolePermissionEntry(variables.getPermissions.objectid, permissionData)>
                <cfelseif variables.getPermissions.contacttype EQ "user">
                    <cfset new cfcs.security.userPermission(Session.DBSource).deleteUserPermission(variables.getPermissions.objectid, permissionData)>
                </cfif>
            <cfelse>
               
                <cfset isInherited = true>
                <cfif variables.getPermissions.contacttype EQ "group">
                    <cfset rolePermissionData = ArrayNew(1)>
                    <cfset arrayAppend(rolePermissionData, permissionData)>
                    <cfset new cfcs.Security.RolePermissions().saveRolePermissionEntry(arguments.objectId, rolePermissionData)>
                <cfelse>
                    <cfset userPermissionData = ArrayNew(1)>
                    <cfset arrayAppend(userPermissionData, permissionData)>
                    <cfset new cfcs.security.userPermission(Session.DBSource).saveUserPermission(arguments.objectId, userPermissionData)>
                </cfif>
                <cfset q = CreateObject("component", "Queue.MessageQueue").init(datasource=session.dbsource, logFile='messageQueue')>
                <cfset q.sendMessage('SecurityCacheHandler', {"ObjectID"=arguments.ObjectId}, session.UnitId)>
            </cfelse>
        </cfif>
    
        <cfreturn true>--->

           
    </cffunction>

 function deleteModuleObjectContact(
        required numeric id,
        required string objectId
        )
        taffy:verb="DELETE"
        hint="Returns site details" 
    {   
       // try {
            var params = arguments;
            var securityUtilObj = application.wirebox.getInstance(name="SecurityUtils");
                params.objectId = securityUtilObj.sanitizeInputs(params.objectId);
            var ModuleRoleCfc = new cfcs.Security.ModuleObjectContacts().init(dbsource=session.DBSource,id=params.id);

            ModuleRoleCfc.deleteModuleObjectContact(id=params.id,objectId=params.objectId);
            return noData().withStatus(200, "deleted");
       // }
       // catch(any ex){
           // var cfcatch = duplicate(ex);
           // include "/IronGate/IronGate.cfm";
           // return noData().withStatus(500, "Internal server error");
        //}
        
    }
   
