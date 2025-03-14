    <cfquery name="qDetails" datasource="#variables.dbSource#">
                    SELECT moduleroleid, contacttype, objectid
                    FROM security.ModuleObjectContacts
                    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.id#">
                </cfquery>
        
       
        
                <cfquery name="variables.getPermissions" datasource="#variables.dbSource#">
                    select rolepermissions 
                    from security.moduleRolepermissions 
                    inner join securityObjects on security.moduleRolepermissions.objectType = securityObjects.objectTypeId
                    where moduleRoleid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qDetails.moduleroleid#">
                    and securityObjects.objectid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qDetails.objectId#">
                </cfquery>
