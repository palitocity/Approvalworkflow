codeunit 53322 "Youtube workflow Setup"
{
    trigger OnRun()
    begin

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        workflowsetup.InsertWorkflowCategory(workflowCategoryCode, workflowCategoryDesc);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', false, false)]
    local procedure OnAfterInsertApprovalsTableRelations()
    begin
        workflowsetup.InsertTableRelation(Database::"Youtube Category Video", 0, DATABASE::"Approval Entry", approvalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', true, true)]
    local procedure OnInsertWorkflowTemplates()
    begin
        InsertYoutubeTemplate()
    end;

    procedure InsertYoutubeTemplate()
    var
        workflow: record Workflow;
    begin
        workflowsetup.InsertWorkflowTemplate(workflow, WorkflowTemplateCode, WorkflowTemplateDesc, workflowCategoryCode);
        InsertYoutubeApprovalWorkFlowDetails(workflow);

        workflowsetup.MarkWorkflowAsTemplate(workflow);
    end;

    procedure InsertYoutubeApprovalWorkFlowDetails(var workflow: record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        BlankDateFormula: DateFormula;
        workflowEventHandling: Codeunit "Yourtube Workflow Evt Handling";
        Youtube: record "Youtube Category Video";

    begin
        workflowsetup.InitWorkflowStepArgument(WorkflowStepArgument, WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver", 0, '', BlankDateFormula, true);


        workflowsetup.InsertDocApprovalWorkflowSteps(workflow, BuildYoutubeTypeConditions(Youtube.Status::Private), workflowEventHandling.RunWorkflowOnSendYoutubeForApprovalCode(),
        BuildYoutubeTypeConditions(Youtube.Status::"Pending Approval"), workflowEventHandling.RunWorkflowOnCancelYoutubeForApprovalCode(), WorkflowStepArgument, true);
    end;

    local procedure BuildYoutubeTypeConditions(Status: Enum Status): Text

    var
        Youtube: Record "Youtube Category Video";
    begin
        Youtube.SetRange(Status, Status);
        exit(StrSubstNo(WorkFlowCond, workflowsetup.Encode((Youtube.GetView(false)))));
    end;


    var
        workflowsetup: Codeunit "Workflow Setup";
        approvalEntry: Record "Approval Entry";
        WorkflowTemplateCode: TextConst ENU = 'YoutubeTmp';
        WorkflowTemplateDesc: TextConst ENU = 'Youtube Workflow Template';
        workflowCategoryCode: TextConst ENU = 'YTCat';
        workflowCategoryDesc: TextConst ENU = 'Youtube Workflow Category';
        WorkFlowCond: label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Youtube">%1</DataItem></DataItems></ReportParameters>', Locked = true;

}