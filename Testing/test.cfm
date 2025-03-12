var DailyReportViewModel = kendo.data.ObservableObject.extend({
  //*************************************************************************
  // Data fields
  //*************************************************************************
  //	saveTimerId: 0,						// Timer Id for interval saving

  //*************************************************************************
  // Report Id
  //*************************************************************************
  reportId: 0,
  //*************************************************************************
  // Report Detail Data
  //*************************************************************************
  contractId: null,
  selectedProjectSites: [],
  showLocationDropdown:false,
  contractNo: "",
  divisionId: 0,
  reportTypeId: 1,
  reportDay: "",
  reporter: "",
  reporterName: "",
  reportDate: null,
  actualDate: null,
  reportNumber: "",
  summaryOfWork: "",
  approvedDate: null,
  approvedBy: "",
  approvedByName: "",
  inspector: "",
  inspectorName: "",
  inspectedDate: null,
  inspectorStartTime: null,
  inspectorEndTime: null,
  inspectorHours: 0,
  contractor: "",
  reviewedBy: "",
  reviewedByName: "",
  reviewedDate: null,
  reReviewedBy: "",
  reReviewedByName: "",
  reReviewedDate: null,
  inspectedBy2: "",
  inspectedBy2Name: "",
  inspectedDate2: null,
  approvalStatus: "",
  useBidItems: false,
  useActivities: false,
  updatedDate: null,
  noWorkPerformed: false,
  reviewedWithContractor: false,
  contractorName: "",
  contractorStartTime: null,
  contractorEndTime: null,
  signInSheet: false,
  signInSheetRemarks: "",
  instanceId: "",
  isMultiDay: false,
  reportEndDate: null,
  milestoneCompletion: "",
  permitNumber: "",
  permitExpirationDate: null,
  custom1: "",
  custom2: "",
  custom3: "",
  custom4: "",
  custom5: "",
  inspectorHoursStraightOT: 0,
  inspectorHoursOT: 0,
  inspectorHoursDoubleOT: 0,
  hasInspectorWorkedThroughLunch: "No",
  hasInspectorHoursNB: "No",
  inspectorHoursNB: 0,
  inspectorHoursNBCategory: "",
  hasInspectorHoursOtherNB: "No",
  inspectorHoursOtherNB: 0,
  inspectorHoursOtherNBCategory: "",
  inspectorHoursTotal: 0,
  inspectorLunchHours: 0,
  canCMEdit: false,
  forceAccountId: 0,

  ShiftReport: "NO",
  ShiftReportNotes: "",
  SurveyReport: "NO",
  SurveyReportNotes: "",
  MTBM: "NO",
  MTBMNotes: "",
  SoilSample: "NO",
  SoilSampleNotes: "",
  AirQuality: "NO",
  AirQualityNotes: "",
  SettlementMonitoring: "NO",
  SettlementMonitoringNotes: "",
  DailyTunnelFootage: "",
  TunnelDewatering: "NO",
  TunnelBoringMachineType: "",
  TunnelMethodUsed: "",

  //*************************************************************************
  // Properties for Work Order tab
  //*************************************************************************
  contractProgram: "",
  contractLocation: "",
  contractSurveyCost: "$0.00",
  constructionCost: "$0.00",

  //*************************************************************************
  // Tab Configuration
  //*************************************************************************
  tabConfig: "",
  defaultTab: 0,
  tabViewModels: [],

  //*************************************************************************
  // Lookup Data
  //*************************************************************************
  lookupReportTypes: dsReportTypes,
  lookupDivisions: dsLookupDivisions,
  lookupContracts: dsContracts,
  lookupJobCategories: dsJobCategories,
  lookupForceAccounts: dsLookupForceAccounts,
  lookupInspectors: dsLookupInspectors,
  lookupInspectors2: dsLookupInspectors2,
  lookupApprovers: dsLookupApprovers,
  lookupReviewers: dsLookupReviewers,
  lookupReReviewers: dsLookupReReviewers,
  lookupLocations: dsLookupLocations,

  //*************************************************************************
  // Dynamic Properties
  //*************************************************************************
  pageTitle: function () {
    if (this.get("reportId") == 0) {
      return drConfig.dailyreportlabel + ": NEW REPORT";
    }
    return drConfig.dailyreportlabel + ": " + this.get("reportNumber");
  },

  // Is this report in Add or Edit mode?  This is NOT a permissions based flag.
  isEdit: function () {
    return !(this.get("reportId") == 0 || this.get("reportId") == -1);
  },

  // Can the user submit this report for approval?  Not locked and in edit mode.
  // 2021-07-01- Added check for instanceid, otherwise user can submit for approval again during workflow
  canSubmit: function () {
    return (
      this.isEdit() &&
      !this.get("isLocked") &&
      !this.get("isSaveLocked") &&
      this.get("instanceId") === ""
    );
  },

  // Can the user approve this report?  In edit mode, not isApproved and user member of inspector approver.
  canApprove: function () {
    return (
      this.isEdit() && !this.get("isApproved") && isMemberOfInspectorApprover
    );
  },

  // Can the user approve this report?  In edit mode, not isApproved and user member of CM.
  canCMApprove: function () {
    return this.isEdit() && !this.get("isApproved") && isCM;
  },

  // TODO: Should you be able to unapprove a report even if it has a workflow instance attached to it?
  canUnapprove: function () {
    return (
      this.isEdit() &&
      this.get("isApproved") &&
      this.get("instanceId") === "" &&
      (isMemberOfInspectorApprover || isCM || currentUser == inspector)
    );
  },

  canUnapproveByRoll: function () {
    return this.get("isApproved") && (isMemberOfInspectorApprover || isCM);
  },

  canPrev: function () {
    return this.get("reportId") != this.get("prev");
  },
  canNext: function () {
    return this.get("reportId") != this.get("next");
  },

  isInspectorLunchHoursEnabled: function () {
    if (this.isEdit()) {
      if (this.get("hasInspectorWorkedThroughLunch") == "Yes ") {
        if (this.get("inspectorLunchHours") == 0) {
          this.set("inspectorLunchHours", 0.5);
        }
        return true;
      }
      this.set("inspectorLunchHours", 0);
    }
    return false;
  },

  isInspectorHoursNBEnabled: function () {
    if (this.isEdit()) {
      if (this.get("hasInspectorHoursNB") == "YES") {
        return true;
      }
    }
    return false;
  },

  isInspectorHoursOtherNBEnabled: function () {
    if (this.isEdit()) {
      if (this.get("hasInspectorHoursOtherNB") == "Yes ") {
        return true;
      }
    }
    return false;
  },

  // Report will be locked if it is submitted for approval (and not in WF) or approved.
  isLocked: false,
  isSaveLocked: false,

  // Report flagged as approved and/or submitted for approval
  isApproved: false,
  isSubmitted: false,

  //*************************************************************************
  // Change support
  //*************************************************************************
  hasChanges: false,

  /**
   * This change event in the view model is fired whenever any property is updated via the set() method.
   * This change event is also bound to all UI fields.
   * [SEM] This change event does NOT get run at all.
   */
  change: function (e) {
    if (!viewModel.get("isSaving")) {
      this.hasChanges = true;
    }
  },

  /**
   * Returns the approval status and if approved includes date and who approved report.
   */
  approvalStatusText: function () {
    let status = this.get("approvalStatus");

    if (drConfig.enable_signoffspanel) {
      return status;
    } else if (status === drConfig.dailyreportapprovaltext) {
      return (
        status +
        " By " +
        this.get("approvedByName") +
        " on " +
        kendo.toString(this.get("approvedDate"), "d")
      );
    }
    return status;
  },

  // Check if Contract dropdown locked (no edit mode).
  isContractLocked: function () {
    if (this.get("isLocked")) return true;
    else if (
      this.get("reportId") == "0" ||
      drConfig.alloweditof_contractid == "true"
    )
      return false;
    else return true;
  },

  // Check if Division dropdown locked
  isDivisionLocked: function () {
    return (
      this.get("isLocked") ||
      this.get("isApproved") ||
      (this.get("instanceId") !== "" && parseInt(this.get("instanceId")) >= 0)
    );
  },

  // Is the inspector field locked?
  isInspectorLocked: function () {
    return (
      this.get("isLocked") ||
      this.get("isApproved") ||
      (this.get("instanceId") !== "" && parseInt(this.get("instanceId")) >= 0)
    );
  },

  // Is the alternate inspector field locked?
  isInspector2Locked: function () {
    return (
      this.get("isLocked") ||
      this.get("isApproved") ||
      (this.get("instanceId") !== "" && parseInt(this.get("instanceId")) >= 0)
    );
  },

  // Is the reviewer field locked?
  isReviewerLocked: function () {
    var readonly = drConfig.enable_reviewerasreadonly === "true";
    return (
      readonly ||
      this.get("isLocked") ||
      this.get("isApproved") ||
      (this.get("instanceId") !== "" && parseInt(this.get("instanceId")) >= 0)
    );
  },

  // Is the RE reviewer field locked?
  isReReviewerLocked: function () {
    return (
      this.get("isLocked") ||
      this.get("isApproved") ||
      (this.get("instanceId") !== "" && parseInt(this.get("instanceId")) >= 0)
    );
  },

  // Is the approver field locked?
  isApproverLocked: function () {
    return (
      this.get("isLocked") ||
      this.get("isApproved") ||
      (this.get("instanceId") !== "" && parseInt(this.get("instanceId")) >= 0)
    );
  },

  updateAddButtons: function () {
  setTimeout(function () {
    var isLocked = viewModel.isLocked;
    var $addButtons = $(".k-grid-add, .dr-grid-add");
    if (isLocked) {
      $addButtons.attr("disabled", "disabled");
      $addButtons.off("click"); 
    } else {
      $addButtons.removeAttr("disabled");
      $addButtons.off("click").on("click", function () {
        resetIdleTimerForTab();
      });
    }
  }, 500);
},
  updateDeleteButtons: function () {
    setTimeout(function () {
      if (viewModel.isLocked) {
        $(".k-grid-delete").attr("disabled", "disabled");
        $(".k-grid-edit").attr("disabled", "disabled");
        $(".button-enabled").removeAttr("disabled");
        $("td").addClass("disabled");

        var columns = $("#gridPayItems").data("kendoGrid").columns;
        columns.forEach(function (column) {
          column.editor = nonEditor;
          column.editable = false;
        });
      } else {
        $(".k-grid-delete").removeAttr("disabled");
        $(".k-grid-edit").removeAttr("disabled");
      }
    }, 500);
  },

  //*************************************************************************
  // loadData() - I load the data into the model from the json data passed in.
  //*************************************************************************
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
      
    //   dsLookupLocations.transport.options.read.data = {
    //     contractId: viewModel.get("contractId")
    //   };
    //   dsLookupLocations.read();

    //   dsLookupLocations.one("requestEnd", function(e) {      
    //     var hasReportLocations = reportLocationIds.length > 0;
    //     var hasContractLocations = e.response.hasProjectLocations === true || (e.response.data && e.response.data.length > 0);

    //     var contractLocationIds = [];
    //     if (hasContractLocations && e.response.data) {
    //       contractLocationIds = e.response.data.map(
    //         location => parseInt(location.projectlocationid, 10)
    //       );
    //     }

    //     var shouldShowDropdown = hasReportLocations || hasContractLocations;
    //     viewModel.set("showLocationDropdown", shouldShowDropdown);
    //     var multiselect = $("#cboProjectLocation").data("kendoMultiSelect");

    //   setTimeout(function () {
    //     if (shouldShowDropdown) {
    //       if (hasReportLocations) {
    //         viewModel.set("selectedProjectSites", reportLocationIds);
      
    //         if (multiselect) {
    //           multiselect.value(reportLocationIds); 
    //           multiselect.trigger("change");
    //         }
    //       } else if (hasContractLocations) {
    //         viewModel.set("selectedProjectSites", []); 
      
    //         if (multiselect) {
    //           multiselect.value([]); 
    //         }
    //       } else {
    //         viewModel.set("selectedProjectSites", []);
      
    //         if (multiselect) {
    //           multiselect.value([]);
    //         }
    //       }
    //     } else {
    //       viewModel.set("selectedProjectSites", []);
    //       if (multiselect) {
    //         multiselect.value([]);
    //       }
    //     }
    //   }, 200);
    // });
    //   dsLookupLocations.read();



        if (data.reportdate !== "") {
          viewModel.set(
            "reportDate",
            kendo.parseDate(data.reportdate, "MM/dd/yyyy")
          );
        }
        if (data.inspecteddate === "") {
          viewModel.set(
            "inspectedDate",
            kendo.parseDate(data.reportdate, "MM/dd/yyyy")
          );
        } else {
          viewModel.set(
            "inspectedDate",
            kendo.parseDate(data.inspecteddate, "MM/dd/yyyy")
          );
        }
        if (data.actualdate !== "") {
          viewModel.set(
            "actualDate",
            kendo.parseDate(data.actualdate, "MM/dd/yyyy")
          );
        }
        viewModel.set("reportNumber", data.rptnum);
        viewModel.set("summaryOfWork", data.summaryofwork);
        if (data.approveddate !== "") {
          viewModel.set(
            "approvedDate",
            kendo.parseDate(data.approveddate, "MM/dd/yyyy")
          );
        } else {
          viewModel.set("approvedDate", null);
        }
        viewModel.set("approvedBy", data.approvedby);
        viewModel.set("approvedByName", data.approvedbyname);
        viewModel.set("reporter", data.reporter);
        viewModel.set("reporterName", data.reportername);
        viewModel.set("inspector", data.inspector);
        if (data.inspectedby2 !== "") {
          viewModel.set("inspectedBy2", data.inspectedby2);
        } else {
          viewModel.set("inspectedBy2", data.inspector);
        }
        viewModel.set("inspectedBy2Name", data.inspectedby2name);
        if (data.inspecteddate2 !== "") {
          viewModel.set(
            "inspectedDate2",
            kendo.parseDate(data.inspecteddate2, "MM/dd/yyyy")
          );
        } else {
          viewModel.set(
            "inspectedDate2",
            kendo.parseDate(data.reportdate, "MM/dd/yyyy")
          );
        }
        viewModel.set("inspectorName", data.inspectorname);
        viewModel.set(
          "inspectorStartTime",
          kendo.parseDate(data.inspectorstarttime)
        );
        viewModel.set(
          "inspectorEndTime",
          kendo.parseDate(data.inspectorendtime)
        );
        viewModel.set("inspectorHours", data.inspectorhours);
        viewModel.set(
          "inspectorHoursStraightOT",
          data.inspectorhoursstraightot
        );
        viewModel.set("inspectorHoursOT", data.inspectorhoursot);
        viewModel.set("inspectorHoursDoubleOT", data.inspectorhoursdoubleot);
        if (drConfig.showtabinspectorextended === true) {
          viewModel.set(
            "hasInspectorWorkedThroughLunch",
            data.hasinspectorworkedthroughlunch
          );
          viewModel.set("hasInspectorHoursNB", data.hasinspectorhoursnb);
        } else {
          if (data.hasinspectorworkedthroughlunch == 1)
            viewModel.set("hasInspectorWorkedThroughLunch", "YES");
          else viewModel.set("hasInspectorWorkedThroughLunch", "NO");
          if (data.hasinspectorhoursnb == 1)
            viewModel.set("hasInspectorHoursNB", "YES");
          else viewModel.set("hasInspectorHoursNB", "NO");
        }
        viewModel.set("inspectorHoursNB", data.inspectorhoursnb);
        viewModel.set(
          "inspectorHoursNBCategory",
          data.inspectorhoursnbcategory
        );
        viewModel.set(
          "hasInspectorHoursOtherNB",
          data.hasinspectorhoursothernb
        );
        viewModel.set("inspectorHoursOtherNB", data.inspectorhoursothernb);
        viewModel.set(
          "inspectorHoursOtherNBCategory",
          data.inspectorhoursothernbcategory
        );
        viewModel.set("inspectorHoursTotal", data.inspectorhourstotal);
        viewModel.set("inspectorLunchHours", data.inspectorlunchhours);
        viewModel.set("contractor", data.contractor);
        viewModel.set("reviewedBy", data.reviewedby);
        viewModel.set("reviewedByName", data.reviewedbyname);
        viewModel.set(
          "reviewedDate",
          kendo.parseDate(data.revieweddate, "MM/dd/yyyy")
        );
        viewModel.set("reReviewedBy", data.rereviewedby);
        viewModel.set("reReviewedByName", data.rereviewedbyname);
        viewModel.set("reReviewedDate", data.rerevieweddate);
        viewModel.set("approvalStatus", data.approvalstatus);
        viewModel.set("useBidItems", data.usebiditems);
        viewModel.set("useActivities", data.useactivities);
        if (data.updateddate !== "") {
          viewModel.set(
            "updatedDate",
            kendo.parseDate(data.updateddate, "MM/dd/yyyy")
          );
        }
        viewModel.set("noWorkPerformed", data.noworkperformed != 0);
        viewModel.set(
          "reviewedWithContractor",
          data.reviewedwithcontractor != 0
        );
        viewModel.set("contractorName", data.contractorname);
        viewModel.set(
          "contractorStartTime",
          kendo.parseDate(data.contractorstarttime)
        );
        viewModel.set(
          "contractorEndTime",
          kendo.parseDate(data.contractorendtime)
        );
        if (data.signinsheet == 1) {
          viewModel.set("signInSheet", true);
        }
        viewModel.set("signInSheetRemarks", data.signinsheetremarks);
        viewModel.set("instanceId", data.instanceid);
        if (data.ismultiday == 1) {
          viewModel.set("isMultiDay", true);
        }
        if (data.reportenddate !== "") {
          viewModel.set(
            "reportEndDate",
            kendo.parseDate(data.reportenddate, "MM/dd/yyyy")
          );
        }
        viewModel.set("milestoneCompletion", data.milestonecompletion);
        viewModel.set("permitNumber", data.permitnumber);
        if (data.permitexpirationdate !== "") {
          viewModel.set(
            "permitExpirationDate",
            kendo.parseDate(data.permitexpirationdate, "MM/dd/yyyy")
          );
        }

        viewModel.set("custom1", data.custom1);
        viewModel.set("custom2", data.custom2);
        viewModel.set("custom3", data.custom3);
        viewModel.set("custom4", data.custom4);
        viewModel.set("custom5", data.custom5);
        viewModel.set("canCMEdit", data.cancmedit);
        if (data.mtbm) viewModel.set("MTBM", "YES");
        else viewModel.set("MTBM", "NO");
        viewModel.set("MTBMNotes", data.mtbmnotes);
        if (data.settlementmonitoring)
          viewModel.set("SettlementMonitoring", "YES");
        else viewModel.set("SettlementMonitoring", "NO");
        viewModel.set(
          "SettlementMonitoringNotes",
          data.settlementmonitoringnotes
        );
        if (data.shiftreport) viewModel.set("ShiftReport", "YES");
        else viewModel.set("ShiftReport", "NO");
        viewModel.set("ShiftReportNotes", data.shiftreportnotes);
        if (data.soilsample) viewModel.set("SoilSample", "YES");
        else viewModel.set("SoilSample", "NO");
        viewModel.set("SoilSampleNotes", data.soilsamplenotes);
        if (data.airquality) viewModel.set("AirQuality", "YES");
        else viewModel.set("AirQuality", "NO");
        viewModel.set("AirQualityNotes", data.airqualitynotes);
        if (data.surveyreport) viewModel.set("SurveyReport", "YES");
        else viewModel.set("SurveyReport", "NO");
        viewModel.set("SurveyReportNotes", data.surveyreportnotes);
        viewModel.set("DailyTunnelFootage", data.dailytunnelfootage);
        viewModel.set("forceAccountId", data.forceaccountid);
        viewModel.set("TunnelMethodUsed", data.tunnelmethodused);
        viewModel.set("TunnelBoringMachineType", data.tunnelboringmachinetype);
        if (data.tunneldewatering) viewModel.set("TunnelDewatering", "YES");
        else viewModel.set("TunnelDewatering", "NO");

        //*************************************************************
        // Update contractId in WorkArea data source
        //*************************************************************
        dsLookupWorkArea.options.transport.read.data.contractId =
          viewModel.contractId;
        //*************************************************************
        // Check for read-only access
        //*************************************************************
        viewModel.set("isLocked", true);
        if (
          data.inspector == currentUser ||
          (isCM && data.cancmedit) ||
          isAdmin ||
          currentUser == data.reporter
        ) {
          viewModel.set("isLocked", false);
        }
        if (data.approvalstatus !== "--" && data.approvalstatus !== "") {
          viewModel.set("isLocked", true);
        }
        if (data.approvalstatus == "Submitted for Approval") {
          viewModel.set("isSubmitted", true);
        } else {
          viewModel.set("isSubmitted", false);
        }
        if (data.approvalstatus == drConfig.dailyreportapprovaltext) {
          viewModel.set("isApproved", true);
        } else {
          viewModel.set("isApproved", false);
        }

        // check WF Steps that can edit (carry over from V2 that was missed in previous updates)
        var tempstr = drConfig.workflowsteps_allowedit;
        if (tempstr == stepId) {
          viewModel.set("isLocked", false);
        } else if (
          tempstr.includes("," + stepId) > 0 ||
          tempstr.includes(stepId + ",") > 0
        ) {
          viewModel.set("isLocked", false);
        } else {
          // do nothing
        }

        viewModel.set("contractProgram", data.contractprogram.trim());
        viewModel.set("contractLocation", data.contractlocation.trim());
        viewModel.set(
          "contractSurveyCost",
          kendo.format("{0:c}", data.contractamount)
        );
        viewModel.set(
          "constructionCost",
          kendo.format("{0:c}", data.constructioncost)
        );

        viewModel.set("prev", data.prev);
        viewModel.set("next", data.next);
        viewModel.hasChanges = false;
      },
    });
  },
  

  fireSave: function () {
   
    if (drConfig != null && drConfig.enableautosaveforv3 == "true") {
      //forcing save if the user changed the tab
      if (viewModel.get("tabChangeTrigger")) {
          let action = "tabChangeSave";
            viewModel.saveData(action);
      }
      else{
        if (currentEditCell && currentEditorField && viewModel.get("isIdle")) {
            let grid = $("#gridPayItems").data("kendoGrid");

            // Retrieve the value from the editor input
            let newValue = currentEditCell.find("input").val();

            if (newValue) {
                // Update the model with the new value
                let dataItem = grid.dataItem(currentEditCell.closest("tr"));
                dataItem.set(currentEditorField, newValue);
                let action = "liveSave";
                viewModel.saveData(action);
            }
        }
        if (
          $(".k-popup-edit-form").length === 0 &&
          viewModel.get("hasChanges") &&
          viewModel.get("isIdle")
        ) {
          let action = "autosave";
          viewModel.set("isSaving", true);
          viewModel
            .saveData(action)
            .then(function (results) {
              if (!results.skippedSave) {
                showSnackbar("Updated Successfully");
                viewModel.set("hasChanges", false);
                viewModel.set("isSaving", false);
              } else {
                console.log("Save Skipped");
              }
            })
            .catch(function (error) {
              viewModel.set("isSaving", false);
            });
        }
    }
  }
  },

  //*************************************************************************
  // saveData() - I attempt to save the report data to the server.
  //*************************************************************************
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

      //*********************************************************************
      // Validate Required Fields
      //*********************************************************************
      var errors = false;
      if (viewModel.reportDate == "" || viewModel.reportDate === null) {
        $("#dteReportDate").parents("div.form-group").addClass("has-error");
        errors = true;
      } else {
        $("#dteReportDate").parents("div.form-group").removeClass("has-error");
      }
      if (viewModel.contractId == "" || viewModel.contractId === null) {
        $("#cboContractNo").parents("div.form-group").addClass("has-error");
        errors = true;
      } else {
        $("#cboContractNo").parents("div.form-group").removeClass("has-error");
      }
      if (viewModel.reportNumber == "" || viewModel.reportNumber === null) {
        $("#txtReportNumber").parents("div.form-group").addClass("has-error");
        errors = true;
      } else {
        $("#txtReportNumber")
          .parents("div.form-group")
          .removeClass("has-error");
      }
      if (drConfig.showdailysigninsheet === "true") {
        if (
          viewModel.signInSheet === false &&
          viewModel.signInSheetRemarks === ""
        ) {
          $("#radSignInSheetYes")
            .parents("div.form-group")
            .addClass("has-error");
          errors = true;
        } else {
          $("#radSignInSheetYes")
            .parents("div.form-group")
            .removeClass("has-error");
        }
      }
      if (drConfig.enable_inspecteddateasreadonly === "false") {
        var dt = viewModel.get("inspectedDate");
        if (dt === "" || dt === null) {
          $("#dtInspectedDate").parents("div.form-group").addClass("has-error");
          errors = true;
        } else {
          $("#dtInspectedDate")
            .parents("div.form-group")
            .removeClass("has-error");
        }
      }
      if (errors) {
        alert(
          "One or more fields are required ... please fill in the indicated fields and try again."
        );
        viewModel.set("isSaveLocked", false);
        return;
      }

      try {
        if (typeof this.contractId === "object") {
          this.contractNo = this.contractId.contractno;
          this.contractId = this.contractId.contractid;
        }

        var reportData = {
          reporterName: $("#reporterName").val(),
          reportId: this.reportId,
          contractId: this.contractId,
          contractNo: this.contractNo,
          divisionId: this.divisionId,
          reportTypeId: this.reportTypeId,
          reportDay: this.reportDay,
          reportDate: toLocalTimeString(this.reportDate),
          actualDate: toLocalTimeString(this.actualDate),
          reportNumber: this.reportNumber,
          summaryOfWork: this.summaryOfWork,
          approvedDate: this.approvedDate,
          approvedBy: this.approvedBy,
          reviewedBy: this.reviewedBy,
          rereviewedBy: this.reReviewedBy,
          inspector: this.inspector,
          inspectedBy2: this.inspectedBy2,
          inspectedDate: this.inspectedDate,
          inspectedDate2: this.inspectedDate2,
          inspectorName: this.inspectorName,
          inspectorStartTime: toLocalTimeString(this.inspectorStartTime),
          inspectorEndTime: toLocalTimeString(this.inspectorEndTime),
          inspectorHours: this.inspectorHours,
          inspectorHoursStraightOT: this.inspectorHoursStraightOT,
          inspectorHoursOT: this.inspectorHoursOT,
          inspectorHoursDoubleOT: this.inspectorHoursDoubleOT,
          hasInspectorWorkedThroughLunch: this.hasInspectorWorkedThroughLunch,
          hasInspectorHoursNB: this.hasInspectorHoursNB,
          inspectorHoursNB: this.inspectorHoursNB,
          inspectorHoursNBCategory: this.inspectorHoursNBCategory,
          hasInspectorHoursOtherNB: this.hasInspectorHoursOtherNB,
          inspectorHoursOtherNB: this.inspectorHoursOtherNB,
          inspectorHoursOtherNBCategory: this.inspectorHoursOtherNBCategory,
          inspectorLunchHours: this.inspectorLunchHours,
          contractor: this.contractor,
          approvalStatus: this.approvalStatus,
          noWorkPerformed: this.noWorkPerformed,
          reviewedWithContractor: this.reviewedWithContractor,
          contractorName: this.contractorName,
          contractorStartTime: toLocalTimeString(this.contractorStartTime),
          contractorEndTime: toLocalTimeString(this.contractorEndTime),
          signInSheet: this.signInSheet,
          signInSheetRemarks: this.signInSheetRemarks,
          isMultiDay: this.isMultiDay,
          reportEndDate: toLocalTimeString(this.reportEndDate),
          milestoneCompletion: this.milestoneCompletion,
          permitNumber: this.permitNumber,
          permitExpirationDate: toLocalTimeString(this.permitExpirationDate),
          test: "HEYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY",
          custom1: this.custom1,
          custom2: this.custom2,
          custom3: this.custom3,
          custom4: this.custom4,
          custom5: this.custom5,
          forceAccountId: this.forceAccountId,
          ShiftReport: this.ShiftReport,
          ShiftReportNotes: this.ShiftReportNotes,
          SurveyReport: this.SurveyReport,
          SurveyReportNotes: this.SurveyReportNotes,
          MTBM: this.MTBM,
          MTBMNotes: this.MTBMNotes,
          SoilSample: this.SoilSample,
          SoilSampleNotes: this.SoilSampleNotes,
          AirQuality: this.AirQuality,
          AirQualityNotes: this.AirQualityNotes,
          SettlementMonitoring: this.SettlementMonitoring,
          SettlementMonitoringNotes: this.SettlementMonitoringNotes,
          DailyTunnelFootage: this.DailyTunnelFootage,
          TunnelMethodUsed: this.TunnelMethodUsed,
          TunnelBoringMachineType: this.TunnelBoringMachineType,
          TunnelDewatering: this.TunnelDewatering,
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
        // Loop over other tabs that are not UA ...
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

              if (showAlert) {
                //only show message on user save - otherwise silent
                alert(results.message);
              }
              if (
                results.reportnumber !== undefined &&
                results.reportnumber != viewModel.reportNumber
              ) {
                viewModel.set("reportNumber", results.reportnumber);
              }

              viewModel.set("updatedBy", results.updatedby);
              viewModel.set("updatedDate", results.updateddate);
              viewModel.set("actualDate", results.actualdate);
              viewModel.set("reporterName", results.reportername);
              viewModel.set("inspectorName", results.inspectorname);
              viewModel.set("contractProgram", results.contractprogram.trim());
              viewModel.set(
                "contractLocation",
                results.contractlocation.trim()
              );
              viewModel.set(
                "contractSurveyCost",
                kendo.format("{0:c}", results.contractamount)
              );
              viewModel.set(
                "constructionCost",
                kendo.format("{0:c}", results.constructioncost)
              );
              if (
                results.reportid !== undefined &&
                results.reportid != viewModel.reportId
              ) {
                viewModel.set("reportId", results.reportid);
                // Update contractId in WorkArea data source
                dsLookupWorkArea.options.transport.read.data.contractId =
                  viewModel.contractId;
                dsLookupTag.options.transport.read.data.reportId =
                  viewModel.reportId;
                dsLookupTag.read();

                viewModel.tabViewModels.length = 0;
                viewModel.tabConfig
                  .read({ reportId: results.reportid })
                  .then(function () {
                    var ts = $("#tsDetails").data("kendoTabStrip");
                    var tab = $(".k-tabstrip-items > .k-first");
                    ts.activateTab(tab);
                  });
                if (dsLookupForceAccounts) {
                  dsLookupForceAccounts.read();
                }
              } else {
                // Loop over all tabs and reload all grids
                this.tabViewModels.forEach(function (item, _index) {
                  item.reloadData(viewModel.reportId);
                });
              }
              viewModel.set("hasChanges", false);
              //call any callBack action
              if (typeof action === "function") {
                action();
              }
              resolve(results);
              var reporterNameDOM = $("#reporterName");
              if (reporterNameDOM.val() !== undefined) {
                if (
                  reporterNameDOM.val() == "" ||
                  reporterNameDOM.val() == null
                ) {
                  try {
                    var dropdownList =
                      reporterNameDOM.data("kendoDropDownList");
                    dropdownList.value(results.reporter);
                    dropdownList.trigger("change");
                  } catch (error) {
                    console.log("Error Message: " + error.message);
                  }
                }
              }

              if (isNewDaily) {
                var editurl = location.href;
                editurl = editurl.replace("New", "Edit");
                editurl =
                  editurl + `&reportId=` + results.reportid + `&inCIP=false`;
                location.replace(editurl);
              }
            } else {
              alert(results.errors[0]);
              reject(results.errors);
            }
            resolve(results);
            viewModel.set("isSaveLocked", false);
          },
          error: function (_jqXHR, textStatus, _errorThrown) {
            alert(
              textStatus +
                "\n\nPlease check your network connection and try again."
            );
            viewModel.set("isSaveLocked", false);
            reject(textStatus);
          },
        });
      } catch (e) {
        alert("Error Saving Data: " + e.message);
        viewModel.set("isSaveLocked", false);
        reject(e.message);
      }
    });
    //return true;
  },

  onSelectContractId: function(e) {
    var that = this;
    var selectedId = e.dataItem.contractid;

    // Update the contractId in the ViewModel
    if (selectedId && selectedId !== that.get("contractId")) {
        that.set("contractId", selectedId);

        // Clear any existing project site selections
        that.set("selectedProjectSites", []);
        that.set("showLocationDropdown", false);

        // Fetch a new report number for the selected contract
        $.ajax({
            type: "GET",
            url: "index.cfm?Fuseaction=DailyReportsV3.actNewReportNumber",
            dataType: "json",
            data: {
                reportId: that.get("reportId"),
                contractId: selectedId,
            },
            success: function(results) {
                if (results.success) {
                    that.set("reportNumber", results.newnumber);

                    // Update contractor information if necessary
                    if (results.contractor !== undefined && results.contractor !== "") {
                        if (that.get("contractorName") === that.get("contractor")) {
                            that.set("contractorName", results.contractor);
                        }
                        that.set("contractor", results.contractor);
                    }

                    // Trigger data loading for project locations
                    dsLookupLocations.one("requestEnd", function(e) {
                        var projectSites = e.response.data;
                        var hasLocations = projectSites && projectSites.length > 0;

                        that.set("showLocationDropdown", hasLocations);

                        if (hasLocations) {
                            that.set("selectedProjectSites", projectSites.map(function(site) {
                                return site.projectlocationid;
                            }));
                        } else {
                            that.set("selectedProjectSites", []);
                        }
                    });

                    dsLookupLocations.read();
                } else {
                    alert(results.message);
                }
            },
            error: function(_jqXHR, _textStatus, errorThrown) {
                alert("Error getting new report number:\n\n" + errorThrown);
            },
        });
    } else {
        that.set("showLocationDropdown", false);
    }
},

  // onSelectContractId: function (e) {
  //   var selectedId = e.dataItem.contractid;

  //   if (selectedId != 0 && selectedId != viewModel.get("contractId")) {
  //     viewModel.set("contractId", selectedId);
  //     // viewModel.set("showLocationDropdown", false);
  //     // dsLookupLocations.data([]);
  //     // Get New Report Number
  //     $.ajax({
  //       type: "GET",
  //       url: "index.cfm?Fuseaction=DailyReportsV3.actNewReportNumber",
  //       dataType: "json",
  //       data: {
  //         reportId: viewModel.get("reportId"),
  //         contractId: selectedId,
  //       },
  //       success: function (results, _status, _options) {
  //         if (results.success) {
  //           viewModel.set("reportNumber", results.newnumber);
  //           if (results.contractor !== undefined && results.contractor !== "") {
  //             if (
  //               viewModel.get("contractorName") == viewModel.get("contractor")
  //             ) {
  //               viewModel.set("contractorName", results.contractor);
  //             }
  //             viewModel.set("contractor", results.contractor);
  //           }
  //           dsLookupLocations.read();
  //           dsLookupLocations.one("requestEnd", function(e) {
  //             var projectSites = e.response.data;
  //             if (projectSites && projectSites.length > 0) {
  //               viewModel.set("showLocationDropdown", true);
  //               viewModel.set("selectedProjectSites", projectSites.map(function(site) {
  //                   return site.projectlocationid;
  //               }));
  //             } else {
  //               viewModel.set("showLocationDropdown", false);
  //               viewModel.set("selectedProjectSites", []);
  //             }
  //           });
  //         } else {
  //           alert(results.message);
  //         }
  //       },
  //       error: function (_jqXHR, _textStatus, errorThrown) {
  //         alert("Error getting new report number:\n\n" + errorThrown);
  //       },
  //     });
  //   }
  // },

  onClickReviewedWithContractor: function (e) {
    if (e.target.checked) {
      if (viewModel.get("contractorName") === "") {
        viewModel.set("contractorName", viewModel.get("contractor"));
      }
    }
  },

  btnBack_onClick: function (_e) {
    var doExit = true;
    var url = "index.cfm?Fuseaction=DailyReportsV3.DailyReportList";
    // save any changes -> then go back
    if (!viewModel.isLocked && viewModel.isEdit()) {
      if (viewModel.get("hasChanges")) {
        if (
          !confirm(
            "There are unsaved changes on this daily report.  Are you sure you want to leave and lose the changes?"
          )
        ) {
          doExit = false;
        }
      }
    }
    if (doExit) {
      if (inCIP) {
        url += "&inCIP=true";
      }
      window.location = url;
    }
  },

  btnSave_onClick: function (_e) {  
    viewModel.saveData();
  },

  btnPrint_onClick: function (_e) {
    var reportURL =
      "index.cfm?Fuseaction=DailyReportsV3.LaunchReport&mrId=" +
      myReportId +
      "&drId=" +
      this.get("reportId");
    window.open(reportURL, "DailyReportToPDF", "status=yes", true);
  },

  btnSubmit_onClick: function (_e) {
    let self = this;
    //this.set("isSaveLocked", true);
    if (
      confirm("Are you sure you want to submit this daily report for approval?")
    ) {
      self.saveData(function () {
        $.ajax({
          url: "index.cfm?Fuseaction=DailyReportsV3.actSubmitForApproval",
          dataType: "json",
          data: {
            reportId: self.get("reportId"),
          },
          success: function (results, _status, _options) {
            if (results.success) {
              self.loadData(self.get("reportId"));
              alert(results.message);
            } else {
              alert(results.message);
              this.set("isSaveLocked", false);
            }
          },
          error: function (_jqXHR, _textStatus, errorThrown) {
            alert(
              "Error submitting daily report for approval:\n\n" + errorThrown
            );
            this.set("isSaveLocked", false);
          },
          context: self,
        });
      });
    } else {
      this.set("isSaveLocked", false);
    }
  },

  btnApprove_onClick: function (_e) {
    if (confirm("Are you sure you want to approve this daily report?")) {
      $.ajax({
        url: "index.cfm?Fuseaction=DailyReportsV3.actApproveDailyReport",
        dataType: "json",
        data: {
          reportId: this.get("reportId"),
        },
        success: function (results, _status, _options) {
          viewModel.saveData();
          if (results.success) {
            this.loadData(this.get("reportId"));
            viewModel.updateAddButtons();
            alert(results.message);
          } else {
            alert(results.message);
          }
        },
        error: function (_jqXHR, _textStatus, errorThrown) {
          alert("Error approving daily report:\n\n" + errorThrown);
        },
        context: this,
      });
    }
  },

  btnUnapprove_onClick: function (_e) {
    if (confirm("Are you sure you want to re-open this daily report?")) {
      $.ajax({
        url: "index.cfm?Fuseaction=DailyReportsV3.actUnapproveDailyReport",
        dataType: "json",
        data: {
          reportId: this.get("reportId"),
        },
        success: function (results, _status, _options) {
          if (results.success) {
            this.loadData(this.get("reportId"));
            alert(results.message);
            location.reload();
          } else {
            alert(results.message);
          }
        },
        error: function (_jqXHR, _textStatus, errorThrown) {
          alert("Error approving daily report:\n\n" + errorThrown);
        },
        context: this,
      });
    }
  },
  btnPrev_onClick: function (_e) {
    let url = new URL(window.location.href);
    let urlParam = url.searchParams.get("reportId");
    $.ajax({
      url: "index.cfm?Fuseaction=DailyReportsV3.jsonLoadDailyReport",
      dataType: "json",
      data: {
        reportId: urlParam,
      },
      success: function (results, _status, _options) {
        var data = results.data[0];
        var pReportId = data.prev;
        location.href =
          "index.cfm?Fuseaction=DailyReportsV3.DailyReportForm&type=Edit&reportId=" +
          pReportId;
      },
    });
  },
  btnNext_onClick: function (_e) {
    let url = new URL(window.location.href);
    let urlParam = url.searchParams.get("reportId");
    $.ajax({
      url: "index.cfm?Fuseaction=DailyReportsV3.jsonLoadDailyReport",
      dataType: "json",
      data: {
        reportId: urlParam,
      },
      success: function (results, _status, _options) {
        var data = results.data[0];
        var nReportId = data.next;
        location.href =
          "index.cfm?Fuseaction=DailyReportsV3.DailyReportForm&type=Edit&reportId=" +
          nReportId;
      },
    });
  },
  btnShowLess_onClick: function (_e) {
    const firstRow = $("#formDetails .row:first-child")[0];
    const button = document.getElementById("btnForShowLess");
    // Toggle visibility of the div
    if (firstRow.style.display === "none") {
      firstRow.style.display = "block"; // Show the div
      button.innerHTML =
        '<i class="fa fas fa-backward colorGreen">&nbsp;</i> Show Less'; // Change button text
    } else {
      firstRow.style.display = "none"; // Hide the div
      button.innerHTML =
        '<i class="fa fas fa-forward colorGreen">&nbsp;</i> Show More'; // Change button text
    }
  },
  onReReviewerChange: function (e) {
    var value = e.sender.value();
    if (drConfig.enable_defaultapprover === "true") {
      if (this.get("approvedBy") === "") {
        this.set("approvedBy", value);
      }
    }
  },

  updateConstructionCost: function (data) {
    var newCost = 0.0;
    data.forEach((item) => {
      newCost += item.itemcost;
    });
    this.set("constructionCost", kendo.format("{0:c}", newCost));
  },
  isSaveDisabled: function () {
    return this.get("isLocked") || this.get("isSaveLocked");
  },
  tabActivate: function(e) {
        viewModel.set("tabChangeTrigger", true);
        const clickedTab = e.item;
        const tabName = clickedTab.querySelector(".k-link")?.textContent.trim();
        
        if(tabName) {
          if (jQuery.isNumeric(reportId) && reportId > 0) {
            callAutoSaveOnTabSelectTrue(tabName);
          }
        }
			},
    
});
// Add this function outside your viewModel
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
}

let idleTimerForTab = null;

function toLocalTimeString(dateIn) {
  var tmpDate = dateIn;

  // If dateIn is not an instance of a Javascript Date object then return an empty string.
  if (dateIn instanceof Date) {
    // Subtract off the timezone offset from the date before converting to ISOString
    tmpDate = new Date(
      dateIn.getTime() - dateIn.getTimezoneOffset() * 60 * 1000
    );
    return tmpDate.toISOString();
  }
  return dateIn;
}

function addSelectOnFocus(_e) {
  var input = $(this);
  clearTimeout(input.data("selectedTimeId"));
  var selectedTimeId = setTimeout(function () {
    input.select();
  });
  input.data("selectedTimeId", selectedTimeId);
}

function removeSelectOnFocus(e) {
  clearTimeout($(this).data("selectedTimeId"));
}

function showSnackbar(message) {
  var snackbar = document.getElementById("snackbar");
  // Set the message
  snackbar.querySelector(".snackbar-message").textContent = message;
  snackbar.classList.add("show");

  // Automatically hide the snackbar after 3 seconds
  setTimeout(function () {
    hideSnackbar();
  }, 3000);
}
function hideSnackbar() {
  document.getElementById("snackbar").classList.remove("show");
}

function callAutoSaveOnTabSelect(){
  if(viewModel.get("isIdle")){
    viewModel.set("tabChangeTrigger",false)
    viewModel.change();
    viewModel.fireSave();
  } 
}

function callAutoSaveOnTabSelectTrue(tabName){
  clearTimeout(idleTimerForTab);
  if (typeof idleTimerForCommonLookup !== 'undefined' && idleTimerForCommonLookup !== null) {
    console.log("Clearing idleTimerForCommonLookup in DRV3");
    clearTimeout(idleTimerForCommonLookup);
  }
  if (typeof idleTimerForDRV3 !== 'undefined' && idleTimerForDRV3 !== null) {
    console.log("Clearing idleTimerForDRV3 in DRV3");
    clearTimeout(idleTimerForDRV3);
  }
  if (typeof idleTimerForEquipmentTab !== 'undefined' && idleTimerForEquipmentTab !== null) {
    console.log("Clearing idleTimerForEquipmentTab in DRV3");
    clearTimeout(idleTimerForEquipmentTab);
  }
  if (typeof idleTimerForForce !== 'undefined' && idleTimerForForce !== null) {
    console.log("Clearing idleTimerForForce in DRV3");
    clearTimeout(idleTimerForForce);
  }
  if (typeof idleTimerForceAccount !== 'undefined' && idleTimerForceAccount !== null) {
    console.log("Clearing idleTimerForceAccount in DRV3");
    clearTimeout(idleTimerForceAccount);
  }
  if (typeof idleTimerForWeather !== 'undefined' && idleTimerForWeather !== null) {
    console.log("Clearing idleTimerForWeather in DRV3");
    clearTimeout(idleTimerForWeather);
  }

  viewModel.set("tabChangeTrigger",true)
  viewModel.change();
  if(!viewModel.get("isSaving")){
    console.log("Saved on select: "+tabName+" tab")
    viewModel.fireSave();}
}

function resetIdleTimerForTab() {
  console.log("User changed tab - idle has been reset in DRV3");
  clearTimeout(idleTimerForTab);
  viewModel.set("isIdle",false);
  idleTimerForTab = setTimeout(handleIdleForTabSelect, drConfig.autosaveinterval); 
}

function handleIdleForTabSelect() { 
  viewModel.set("isIdle",true); 
  console.log("User activity not detected since last tab change for 30 seconds");
   if (jQuery.isNumeric(reportId) && reportId > 0) {
  callAutoSaveOnTabSelect();
  }
}

