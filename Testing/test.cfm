<cfquery name="qryDailyReport" datasource="#Session.DBSource#">
    INSERT INTO DailyReport (/* Other Columns */)
    VALUES (/* Other Values */)
</cfquery>

<cfset reportId = qryDailyReport.generatedKey> <!-- Ensure this gets the correct ID -->

<cfif structKeyExists(dataDetails, "projectSiteIds") AND arrayLen(dataDetails.projectSiteIds) GT 0>
    <cfloop array="#dataDetails.projectSiteIds#" index="projectSiteId">
        <cfquery name="qryInsertProjectSite" datasource="#Session.DBSource#">
            INSERT INTO Dailyreport_ProjectSite (
                reportId,
                projectSiteId
            ) VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#reportId#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#projectSiteId#">
            )
        </cfquery>
    </cfloop>
</cfif>



=================

<cfquery name="qryUpdateDailyReport" datasource="#Session.DBSource#">
    UPDATE DailyReport
    SET /* Other Fields */
    WHERE reportId = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataDetails.reportId#">
</cfquery>

<cfif dataDetails.ReportId NEQ "0">
    <cfset reportId = dataDetails.ReportId>

    <!--- First delete old project sites --->
    <cfquery name="qryDeleteProjectSites" datasource="#Session.DBSource#">
        DELETE FROM Dailyreport_ProjectSite
        WHERE reportId = <cfqueryparam cfsqltype="cf_sql_integer" value="#reportId#">
    </cfquery>

    <!--- Insert new project sites --->
    <cfif structKeyExists(dataDetails, "projectSiteIds") AND arrayLen(dataDetails.projectSiteIds) GT 0>
        <cfloop array="#dataDetails.projectSiteIds#" index="projectSiteId">
            <cfquery name="qryInsertProjectSite" datasource="#Session.DBSource#">
                INSERT INTO Dailyreport_ProjectSite (
                    reportId,
                    projectSiteId
                ) VALUES (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#reportId#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#projectSiteId#">
                )
            </cfquery>
        </cfloop>
    </cfif>
</cfif>
