  <cfquery name="qObjId" datasource="#variables.dbSource#">
            SELECT objectid
            FROM security.ModuleObjectContacts
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.id#">
        </cfquery>
        <!--- Fetch module details and role permissions in a single query --->
        <cfquery name="qDetails" datasource="#variables.dbSource#">
            SELECT moc.moduleroleid, moc.contacttype, moc.objectid, moc.contactid, 
                   mrp.rolepermissions, so.objectTypeId
            FROM security.ModuleObjectContacts moc
            INNER JOIN security.moduleRolepermissions mrp ON moc.moduleroleid = mrp.moduleRoleid
            INNER JOIN securityObjects so ON mrp.objectType = so.objectTypeId
            WHERE moc.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
            AND so.objectid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#moc.objectid#">
        </cfquery>
