loadData: function (pReportId) {
    var viewModel = this;
    this.set("reportId", pReportId);

    $.ajax({
        url: "index.cfm?Fuseaction=DailyReportsV3.jsonLoadDailyReport",
        dataType: "json",
        data: { reportId: pReportId },
        success: function (results) {
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
        },
        error: function (xhr, status, error) {
            console.error("Error loading report data:", error);
        }
    });
}
