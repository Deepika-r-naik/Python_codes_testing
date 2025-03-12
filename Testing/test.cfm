// Location data source
var dsLookupLocations = new kendo.data.DataSource({
 serverFiltering: true,
 transport: {
 read: {
 url: "index.cfm?Fuseaction=DailyReportsV3.jsonLookupLocations",
 dataType: "json",
 data: function() {
 return {
 contractId: typeof viewModel !== 'undefined' ? viewModel.get("contractId") || -1 : -1
 };
 }
 }
 },
 schema: {
 total: "recordcount",
 data: "data",
 model: {
 id: "projectlocationid",
 fields: {
 projectlocationid: { type: "number" },
 projectlocationname: { type: "string" }
 }
 }
 }
});// In your existing viewModel, replace just the onSelectContractId function:
onSelectContractId: function(e) {
 var that = this;
 var selectedValue = e.sender.value();
 that.set("contractId", selectedValue);
 
 // Clear any existing project site selections
 that.set("selectedProjectSites", []);
 
 if (selectedValue) {
 // Instead of setTimeout, use the Kendo DataSource events
 dsLookupLocations.one("requestEnd", function() {
 // Check if locations exist for this contract
 var hasLocations = dsLookupLocations.data().length > 0;
 that.set("showLocationDropdown", hasLocations);
 
 // If editing a report, load saved locations
 if (that.get("reportId") && hasLocations) {
 loadReportProjectSites(that.get("reportId"));
 }
 });
 
 // Trigger data loading
 dsLookupLocations.read();
 } else {
 that.set("showLocationDropdown", false);
 }
}// Add this function outside your viewModel
function loadReportProjectSites(reportId) {
 if (!reportId) return;
 
 $.ajax({
 url: "index.cfm?Fuseaction=DailyReportsV3.jsonGetReportProjectSites",
 dataType: "json",
 data: { reportId: reportId },
 success: function(response) {
 if (response && response.data && response.data.length > 0) {
 var siteIds = response.data.map(function(item) {
 return item.projectSiteId;
 });
 
 // Set the selected project sites in the viewModel
 viewModel.set("selectedProjectSites", siteIds);
 
 // Force the multiselect widget to refresh its selection
 var multiselect = $("#cboProjectLocation").data("kendoMultiSelect");
 if (multiselect) {
 multiselect.value(siteIds);
 multiselect.trigger("change");
 }
 }
 },
 error: function(xhr, status, error) {
 console.error("Error loading project sites:", error);
 }
 });
}// Add this to your existing document ready function
$(document).ready(function() {
 // Your existing code...
 
 // If editing an existing report, check if we need to load project sites
 var reportId = viewModel.get("reportId");
 if (reportId && viewModel.get("contractId")) {
 // Use the data binding event of the locations dropdown
 var multiselect = $("#cboProjectLocation").data("kendoMultiSelect");
 if (multiselect) {
 dsLookupLocations.one("requestEnd", function() {
 var hasLocations = dsLookupLocations.data().length > 0;
 viewModel.set("showLocationDropdown", hasLocations);
 
 if (hasLocations) {
 loadReportProjectSites(reportId);
 }
 });
 dsLookupLocations.read();
 }
 }
});



 SELECT drps.projectSiteId
 FROM Dailyreport_ProjectSite drps
 WHERE drps.reportId = 






 
 
 
 
 DELETE FROM Dailyreport_ProjectSite
 WHERE reportId = 
 
 
 
 
 
 
 INSERT INTO Dailyreport_ProjectSite (
 reportId,
 projectSiteId
 ) VALUES (
 ,
 
 )
 
 
 
 

 
 
 
 
 INSERT INTO Dailyreport_ProjectSite (
 reportId,
 projectSiteId
 ) VALUES (
 ,
 
 )

loadData: function (pReportId) {
    var viewModel = this;

    this.set("reportId", pReportId);
    // Load the ForceAcounts lookup
    //		dsLookupForceAccounts.transport.options.read.data.reportId = pReportId;
    //		dsLookupForceAccounts.read();

    //*************************************************************************
    // Load the Report Details
    //*************************************************************************
    $.ajax({
      url: "index.cfm?Fuseaction=DailyReportsV3.jsonLoadDailyReport",
      dataType: "json",
      data: {
        reportId: pReportId,
      },
      success: function (results, _status, _options) {
        var data = results.data[0];
        viewModel.set("contractId", data.contractid);
        viewModel.set("contractNo", data.contractno);
        viewModel.set("reportTypeId", data.reporttypeid);
        viewModel.set("divisionId", data.divisionid);
        viewModel.set("reportDay", data.reportday);

        var reportLocationIds = results.data
      .filter(item => item.projectsiteid)
      .map(item => parseInt(item.projectsiteid, 10))
      .filter((value, index, self) => self.indexOf(value) === index);
      
      dsLookupLocations.transport.options.read.data = {
        contractId: viewModel.get("contractId")
      };
      dsLookupLocations.read();

      dsLookupLocations.one("requestEnd", function(e) {      
        var hasReportLocations = reportLocationIds.length > 0;
        var hasContractLocations = e.response.hasProjectLocations === true || (e.response.data && e.response.data.length > 0);

        var contractLocationIds = [];
        if (hasContractLocations && e.response.data) {
          contractLocationIds = e.response.data.map(
            location => parseInt(location.projectlocationid, 10)
          );
        }

        var shouldShowDropdown = hasReportLocations || hasContractLocations;
        viewModel.set("showLocationDropdown", shouldShowDropdown);
        var multiselect = $("#cboProjectLocation").data("kendoMultiSelect");

      setTimeout(function () {
        if (shouldShowDropdown) {
          if (hasReportLocations) {
            viewModel.set("selectedProjectSites", reportLocationIds);
      
            if (multiselect) {
              multiselect.value(reportLocationIds); 
              multiselect.trigger("change");
            }
          } else if (hasContractLocations) {
            viewModel.set("selectedProjectSites", []); 
      
            if (multiselect) {
              multiselect.value([]); 
            }
          } else {
            viewModel.set("selectedProjectSites", []);
      
            if (multiselect) {
              multiselect.value([]);
            }
          }
        } else {
          viewModel.set("selectedProjectSites", []);
          if (multiselect) {
            multiselect.value([]);
          }
        }
      }, 200);
    });
      dsLookupLocations.read();

