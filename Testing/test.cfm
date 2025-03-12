<!--- Determine if editing or inserting a new report --->
<cfif dataDetails.ReportId EQ "0">
    <!--- New report: Assign new Report ID --->
    <cfset reportId = qryDailyReport.reportId>
<cfelse>
    <!--- Existing report: Use provided Report ID --->
    <cfset reportId = dataDetails.ReportId>

    <!--- Delete existing project site associations --->
    <cfquery name="qryDeleteProjectSites" datasource="#Session.DBSource#">
        DELETE FROM Dailyreport_ProjectSite
        WHERE reportId = <cfqueryparam cfsqltype="cf_sql_integer" value="#reportId#">
    </cfquery>
</cfif>

<!--- Insert new project site associations if there are any --->
<cfif structKeyExists(dataDetails, "projectSiteIds") AND arrayLen(dataDetails.projectSiteIds) GT 0>
    <cfquery name="qryInsertProjectSites" datasource="#Session.DBSource#">
        INSERT INTO Dailyreport_ProjectSite (reportId, projectSiteId)
        VALUES 
        <cfloop array="#dataDetails.projectSiteIds#" index="projectSiteId">
            (<cfqueryparam cfsqltype="cf_sql_integer" value="#reportId#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#projectSiteId#">)
            <cfif NOT arrayLast(dataDetails.projectSiteIds) EQ projectSiteId>,</cfif>
        </cfloop>
    </cfquery>
</cfif>
