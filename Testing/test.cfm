<!--- Handle project sites for both new and existing reports --->
					<cfif dataDetails.ReportId NEQ "0">
						<!--- For existing reports, only delete if we have projectSiteIds key --->
						<cfif structKeyExists(dataDetails, "projectSiteIds")>
							<!--- First delete existing entries --->
							<cfquery name="qryDeleteProjectSites" datasource="#Session.DBSource#">
								DELETE FROM Dailyreport_ProjectSite
								WHERE reportId = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataDetails.reportId#">
							</cfquery>
							
							<!--- Then insert the new entries --->
							<cfif isArray(dataDetails.projectSiteIds) AND arrayLen(dataDetails.projectSiteIds) GT 0>
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
					<cfelse>
						<!--- For new reports, handle project sites directly --->
						<cfif structKeyExists(dataDetails, "projectSiteIds") AND isArray(dataDetails.projectSiteIds) AND arrayLen(dataDetails.projectSiteIds) GT 0>
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
					</cfif>

		<cfset reportId = qryDailyReport.reportId>
					<cfif structKeyExists(dataDetails, "projectSiteIds") AND isArray(dataDetails.projectSiteIds) AND arrayLen(dataDetails.projectSiteIds) GT 0>
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
