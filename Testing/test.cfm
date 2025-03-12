 saveData: function (action) {
    if(viewModel.get("isSaveLocked")){
      return new Promise((resolve, reject) => {
       var results={"skippedSave":true};
        
       resolve(results);
      });
    }
    return new Promise((resolve, reject) => {
      var showAlert = false;
      if (typeof action === "undefined") {
        action = function () {};
        showAlert = true;
      }
      var viewModel = this;
      viewModel.set("isSaveLocked", true);
 var reportData = {
          reporterName: $("#reporterName").val(),
          reportId: this.reportId,
          contractId: this.contractId,
          projectSiteIds:this.selectedProjectSites,
        };
        if (this.selectedProjectSites && this.selectedProjectSites.length > 0) {
          reportData.projectSiteIds = [];
          for (var i = 0; i < this.selectedProjectSites.length; i++) {
              var site = this.selectedProjectSites[i];
              if (typeof site === 'object' && site.projectlocationid) {
                  reportData.projectSiteIds.push(site.projectlocationid);
              } else if (typeof site === 'number') {
                  reportData.projectSiteIds.push(site);
              } 
          }
      } else {
          reportData.projectSiteIds = [];
      }

   this.tabViewModels.forEach(function (item, _index) {
          if (item.storageField !== "") {
            // If the storageField item is non-blank, then store the changed data into
            // the appropriate reportData item (including UA forms).
            reportData[item.storageField] = item.getDataChanges();
          }
        });
        var jsonData = kendo.stringify(reportData);
        var isNewDaily = !this.isEdit();
        // Save Details
        $.ajax({
          method: "POST",
          url: "index.cfm?Fuseaction=DailyReportsV3.actSaveDailyReport",
          dataType: "json",
          contentType: "application/json",
          data: jsonData,
          context: viewModel,
          success: function (results, _status, _options) {
             results.skippedSave=false;
            if (results.success) {
              // Loop over other tabs that must use an internal saving mechanism.
              this.tabViewModels.forEach(function (item, _index) {
                if (item.storageField === "") {
                  // If the storageField item is BLANK, then call the saveData() method to
                  // tell the tab to save its data on its own.
                  item.saveData();
                }
              });


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

var reportLocationIds = results.data
      .filter(item => item.projectsiteid)
      .map(item => parseInt(item.projectsiteid, 10))
      .filter((value, index, self) => self.indexOf(value) === index);

      var reportLocationIds = results.data
                .filter(item => item.projectsiteid)
                .map(item => parseInt(item.projectsiteid, 10))
                .filter((value, index, self) => self.indexOf(value) === index);

            // Ensure the DataSource uses the correct contractId
            dsLookupLocations.transport.options.read.data = { contractId: viewModel.get("contractId") };

            // Listen for when the request completes
            dsLookupLocations.one("requestEnd", function (e) {
                var hasContractLocations = e.response && e.response.data && e.response.data.length > 0;
                var contractLocationIds = hasContractLocations ? e.response.data.map(location => parseInt(location.projectlocationid, 10)) : [];

                // Determine if the dropdown should be shown
                var shouldShowDropdown = reportLocationIds.length > 0 || hasContractLocations;
                viewModel.set("showLocationDropdown", shouldShowDropdown);

                var multiselect = $("#cboProjectLocation").data("kendoMultiSelect");

                if (multiselect) {
                    if (reportLocationIds.length > 0) {
                        viewModel.set("selectedProjectSites", reportLocationIds);
                        multiselect.value(reportLocationIds);
                    } else {
                        viewModel.set("selectedProjectSites", []);
                        multiselect.value([]);
                    }
                    multiselect.trigger("change");
                }
            });

            // Fetch location data for the contract
            dsLookupLocations.read();
