	<cfset reportId = qryDailyReport.reportId>
					<cfif structKeyExists(dataDetails, "projectSiteIds") AND isArray(dataDetails.projectSiteIds) AND arrayLen(dataDetails.projectSiteIds) GT 0>
						<cflog text="Processing #arrayLen(dataDetails.projectSiteIds)# project site IDs">
						
						<cfloop array="#dataDetails.projectSiteIds#" index="projectSiteId">
								<cfquery name="qryDailyreportProjectSite" datasource="#Session.DBSource#">
									INSERT INTO Dailyreport_ProjectSite (
										reportId,
										projectSiteId
									) VALUES (
									<cfqueryparam cfsqltype="cf_sql_integer" value="#reportId#">,
									
									<cfqueryparam value="#projectSiteId#" cfsqltype="cf_sql_integer">
									)
								</cfquery>
					</cfloop>
				</cfif>

<cfif dataDetails.ReportId NEQ "0">
					<cfquery name="qryDeleteProjectSites" datasource="#Session.DBSource#">
						DELETE FROM Dailyreport_ProjectSite
						WHERE reportId = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataDetails.reportId#">
					</cfquery>

					<cfif structKeyExists(dataDetails, "projectSiteIds") AND isArray(dataDetails.projectSiteIds)>
						<cfloop array="#dataDetails.projectSiteIds#" index="projectSiteId">
							<cfquery name="qryInsertProjectSite" datasource="#Session.DBSource#">
								INSERT INTO Dailyreport_ProjectSite (
									reportId,
									projectSiteId
								) VALUES (
									<cfqueryparam cfsqltype="cf_sql_integer" value="#dataDetails.reportId#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#projectSiteId#">
								)
							</cfquery>
						</cfloop>
					</cfif>
				</cfif>
