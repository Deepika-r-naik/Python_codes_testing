<!--- Check if it's a new report or an edit --->
<cfif dataDetails.ReportId EQ "0">
    <!--- Creating a new report: Fetch the newly created Report ID --->
    <cfset reportId = qryDailyReport.reportId>

    <cfif structKeyExists(dataDetails, "projectSiteIds") AND isArray(dataDetails.projectSiteIds) AND arrayLen(dataDetails.projectSiteIds) GT 0>
        <cflog text="Processing #arrayLen(dataDetails.projectSiteIds)# project site IDs for new report #reportId#">

        <cfloop array="#dataDetails.projectSiteIds#" index="projectSiteId">
            <cfquery name="qryDailyreportProjectSite" datasource="#Session.DBSource#">
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

<cfelse>
    <!--- Editing an existing report: Delete old entries and insert new ones --->
    <cfset reportId = dataDetails.ReportId>

    <cfquery name="qryDeleteProjectSites" datasource="#Session.DBSource#">
        DELETE FROM Dailyreport_ProjectSite
        WHERE reportId = <cfqueryparam cfsqltype="cf_sql_integer" value="#reportId#">
    </cfquery>

    <cfif structKeyExists(dataDetails, "projectSiteIds") AND isArray(dataDetails.projectSiteIds) AND arrayLen(dataDetails.projectSiteIds) GT 0>
        <cflog text="Processing #arrayLen(dataDetails.projectSiteIds)# project site IDs for existing report #reportId#">
        
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
