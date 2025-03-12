loadData: function (pReportId) {
    var viewModel = this;
    viewModel.set("reportId", pReportId);

    $.ajax({
        url: "index.cfm?Fuseaction=DailyReportsV3.jsonLoadDailyReport",
        dataType: "json",
        data: { reportId: pReportId },
        success: function (results, _status, _options) {
            var data = results.data[0];

            var reportLocationIds = results.data
                .filter(item => item.projectsiteid)
                .map(item => parseInt(item.projectsiteid, 10))
                .filter((value, index, self) => self.indexOf(value) === index);

            // Ensure the DataSource uses the correct contractId
            dsLookupLocations.transport.options.read.data = { contractId: viewModel.get("contractId") };

            // Fetch location data for the contract and update UI after completion
            dsLookupLocations.fetch().then(function() {
                var hasContractLocations = dsLookupLocations.data().length > 0;
                var contractLocationIds = hasContractLocations 
                    ? dsLookupLocations.data().map(location => parseInt(location.projectlocationid, 10)) 
                    : [];

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
        }
    });
}
