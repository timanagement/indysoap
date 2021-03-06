{
IndySOAP: WSDL -> Pascal conversion for a proprietary soap framework
}
Unit IdSoapWsdlAdv;

{$I IdSoapDefines.inc}

Interface

Uses
  Classes,
  TypInfo,
  Contnrs,
  IdSoapConsts,
  IdSoapDebug,
  IdSoapXml,
  IdSoapITI,
  IdSoapNamespaces,
  IdSoapRpcPacket,
  IdSoapUtilities,
  IdSoapWsdl;

Type

  TIdSoapTypeType = (idttSimple, idttSet, idttList, idttClass);

  TIdSoapWSDLPascalFragment = Class (TIdBaseObject)
  Private
    FHidden : Boolean;
    FPascalName : String;
    FAncestor : String;
    FTypeType : TIdSoapTypeType;
    FCode : String;
    FDecl : String;
    FImpl : String;
    FIncludeInPascal : Boolean;
    FFieldType : TFieldType;

    priv1 : String;
    priv2 : String;
    pub : String;
    dest : String;
    def : String;
    ass : String;
  Public
    Constructor Create;
  End;

  TPortTypeEntry = Class (TIdBaseObject)
  Private
    FSvc : TIdSoapWSDLService;
    FPort : TIdSoapWSDLPortType;
    FBind : TIdSoapWSDLBinding;
  End;

  TIdSoapWSDLToAdvConvertor = Class (TIdBaseObject)
  Private
    FComments : TStringList;
    FExemptTypes : TStringList;
    FInterfaceUsesClause : TStringList;
    FImplementationUsesClause : TStringList;
    FSoapSvcPorts : TObjectList;
    FValidPortTypes : TStringList;
    FDefinedTypes : TStringList;
    FUsedPascalIDs : TStringList;
    FReservedPascalNames : TStringList;

    FStream : TStream;
    FWsdl : TIdSoapWsdl;
    FIti : TIdSoapITI;
    FOneInterface : TIdSoapITIInterface;

    FUnitName : String;
    FWSDLSource: String;
    // FDefaultEncoding : TIdSoapEncodingMode;
    FResourceFileName: String;
    FOnlyOneInterface: Boolean;
    FOneInterfaceName: String;
    FProjectName: String;

    Function AsSymbolName(AValue : String) : TSymbolName;
    Procedure AddUnit(AUnitName : String; AInInterface : Boolean);
    Procedure Write(Const s:String);
    Procedure Writeln(Const s:String);
    Procedure ListSoapSvcPorts;
    Procedure ListDescendents(ADescendents : TObjectList; AName : TQName);
    Procedure ProcessSoapHeaders(AMsg : TIdSoapWSDLBindingOperationMessage; AMethod : TIdSoapITIMethod; AHeaderList : TIdSoapITIParamList);
    Procedure ProcessOperation(AInterface : TIdSoapITIInterface; AOp : TIdSoapWSDLPortTypeOperation; ABind : TIdSoapWSDLBinding);
    Procedure ProcessMessageParts(AMethod : TIdSoapITIMethod; AMessage : TIdSoapWSDLMessage; AOp : TIdSoapWSDLBindingOperationMessage; AIsOutput : Boolean);
    Function  ProcessType(AMethod : TIdSoapITIMethod; AName: String; AOp : TIdSoapWSDLBindingOperationMessage; AType : TQName; Var aFieldType : TFieldType):String;
    Function  ProcessElement(AMethod : TIdSoapITIMethod; AName: String; AOp : TIdSoapWSDLBindingOperationMessage; AElement : TQName; Var aFieldType : TFieldType):String;
    Function GetInterfaceForEntry(AEntry : TPortTypeEntry):TIdSoapITIInterface;
    Procedure WriteITI;
    Procedure WriteClientImpl();
    Procedure WriteMethod(AMeth : TIdSoapITIMethod; ADefSoapAction : String);
    Procedure WriteMethodImpl(aIntf : TIdSoapITIInterface; AMeth : TIdSoapITIMethod; ADefSoapAction : String);
    Function  DescribeParam(AParam : TIdSoapITIParameter):String;
    Function  WriteComplexType(AMethod : TIdSoapITIMethod; ATypeName : TQName; AClassName : String; AType : TIdSoapWsdlComplexType; AOp : TIdSoapWSDLBindingOperationMessage; Out VAncestor, VImpl, VReg : String):String;
    Function  TypeIsArray(AType : TQName):Boolean;
    Procedure ProcessPorts;
    Procedure WriteHeader;
    Procedure WriteUsesClause(AList : TStringList);
    Procedure WriteTypes;
    Procedure WriteImpl;
//    Function  AllMethodsAreDocument(AIntf : TIdSoapITIInterface):Boolean;
    Procedure LoadReservedWordList;
    Function  ChoosePascalNameForType(Const ASoapName: String): String;
    Function  ChoosePascalName(Const AClassName, ASoapName : String; AAddNameChange : Boolean):String;
    Function CreateArrayType(AMethod: TIdSoapITIMethod; AOp : TIdSoapWSDLBindingOperationMessage; ABaseType: TQName): String;
    Procedure ProcessRPCOperation(AOp: TIdSoapWSDLPortTypeOperation; AOpBind : TIdSoapWSDLBindingOperation; AMethod: TIdSoapITIMethod);
    Procedure ProcessDocLitOperation(AOp: TIdSoapWSDLPortTypeOperation; AMethod: TIdSoapITIMethod);
    Function FindRootElement(AMethod : TIdSoapITIMethod; AName: String): TIdSoapWsdlElementDefn;
    Procedure ProcessDocLitParts(AMethod: TIdSoapITIMethod; ABaseElement: TIdSoapWSDLElementDefn; AIsOutput: Boolean);
    Function GetOpNamespace(AOp: TIdSoapWSDLPortTypeOperation;
      ABind: TIdSoapWSDLBinding): String;
    Function GetEnumName(AEnumType, AEnumValue: String): String;
    Function MakeInterfaceForEntry(
      AEntry: TPortTypeEntry): TIdSoapITIInterface;
    Function GetServiceSoapAddress(AService: TIdSoapWSDLService): String;
    Procedure CreateParamClasses;
    Procedure CreateParamClass(oIntf : TIdSoapITIInterface; oMethod : TIdSoapITIMethod; sSuffix : String; aFlags : TParamFlags);
    Procedure DefineParameter(oMethod : TIdSoapITIMethod; oFrag : TIdSoapWSDLPascalFragment; sName : String; sXMLName : String; sNameOfType : String; aType : TFieldType);
  Public
    Constructor Create;
    destructor Destroy; Override;
    Property Comments : TStringList Read FComments;
    Property UnitName_ : String Read FUnitName Write FUnitName;
    Property WSDLSource : String Read FWSDLSource Write FWSDLSource;
    Property ProjectName : String read FProjectName write FProjectName;
    Property ResourceFileName : String Read FResourceFileName Write FResourceFileName;
    Property OneInterfaceName : String Read FOneInterfaceName Write FOneInterfaceName;
    Property OnlyOneInterface : Boolean Read FOnlyOneInterface Write FOnlyOneInterface;
    Procedure SetExemptTypes(AList : String);
    Procedure SetUsesClause(AList : String);
    Procedure Convert(AWsdl : TIdSoapWsdl; AStream : TStream);
  End;

Implementation

Uses
  ActiveX,
  ComObj,
  IdSoapClasses,
  IdSoapExceptions,
  {$IFDEF UNICODE}
  {$ELSE}
  IdSoapOpenXML,
  {$ENDIF}
  IdSoapTypeRegistry,
  IdSoapTypeUtils,
  SysUtils;

Const
  ASSERT_UNIT = 'IdSoapWsdlPascal';
  MULTIPLE_ADDRESSES = 'Multiple Addresses For this Interface (or Indeterminate)';


Procedure Check(ACondition : Boolean; AComment :String);
Begin
  If Not ACondition Then
    Begin
    Raise EIdSoapException.Create(AComment);
    End;
End;

{ TIdSoapWSDLPascalFragment }

Constructor TIdSoapWSDLPascalFragment.Create;
Begin
  Inherited;
  FIncludeInPascal := True;
End;

{ TIdSoapWSDLToAdvConvertor }

Constructor TIdSoapWSDLToAdvConvertor.Create;
Begin
  Inherited;
  FComments := TStringList.Create;
  FSoapSvcPorts := TObjectList.Create(False);
  FValidPortTypes := TIdStringList.Create(True);
  FDefinedTypes := TIdStringList.Create(True);
  FUsedPascalIDs := TStringList.Create;
  FReservedPascalNames := TStringList.Create;
  FExemptTypes := TStringList.Create;
  FInterfaceUsesClause := TStringList.Create;
  FInterfaceUsesClause.Sorted := True;
  FInterfaceUsesClause.Duplicates := dupIgnore;
  FImplementationUsesClause := TStringList.Create;
  FImplementationUsesClause.Sorted := True;
  FImplementationUsesClause.Duplicates := dupIgnore;
  LoadReservedWordList;
End;

Destructor TIdSoapWSDLToAdvConvertor.Destroy;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.destroy';
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  FreeAndNil(FReservedPascalNames);
  FreeAndNil(FUsedPascalIDs);
  FreeAndNil(FDefinedTypes);
  FreeAndNil(FValidPortTypes);
  FreeAndNil(FSoapSvcPorts);
  FreeAndNil(FComments);
  FreeAndNil(FExemptTypes);
  FreeAndNil(FInterfaceUsesClause);
  FreeAndNil(FImplementationUsesClause);
  Inherited;
End;

Procedure TIdSoapWSDLToAdvConvertor.Convert(AWsdl: TIdSoapWsdl; AStream: TStream);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.Convert';
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AWsdl.TestValid(TIdSoapWsdl), ASSERT_LOCATION+': WSDL is not valid');
  Assert(Assigned(AStream), ASSERT_LOCATION+': Stream is not valid');
  Assert(IsValidIdent(UnitName_), ASSERT_LOCATION+': UnitName is not valid');

  FStream := AStream;
  FWsdl := AWsdl;
  FComments.Clear;

  AddUnit('AdvPersistents', True);
  AddUnit('AdvPersistentLists', True);
  AddUnit('AdvStringLists', True);
  AddUnit('AdvWebServiceClients', True);
  AddUnit('AdvFactories', False);

  AWsdl.Validate; // check that it's internally self consistent
  ListSoapSvcPorts;
  IdRequire(FValidPortTypes.count > 0, 'Error converting WSDL to Pascal Source: No acceptable SOAP Services were found in WSDL');
  FIti := TIdSoapITI.Create;
  Try
    ProcessPorts;

    CreateParamClasses;
    WriteHeader;
    WriteUsesClause(FInterfaceUsesClause);
    WriteTypes;
    WriteITI;
    Writeln('Implementation');
    Writeln('');
    If FResourceFileName <> '' Then
      Begin
      Writeln('{$R '+FResourceFileName+'}');
      Writeln('');
      End;
    WriteUsesClause(FImplementationUsesClause);
    WriteImpl;
    Writeln('End.');
  Finally
    FreeAndNil(FIti);
  End;
End;

Procedure TIdSoapWSDLToAdvConvertor.Write(Const s: String);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.Write';
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  if Length(s) > 0 Then
    FStream.Write(s[1], Length(s));
End;

Procedure TIdSoapWSDLToAdvConvertor.Writeln(Const s: String);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.WriteLn';
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Write(s+EOL_WINDOWS);
End;

Procedure TIdSoapWSDLToAdvConvertor.ListSoapSvcPorts;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.ListSoapSvcPorts';
Var
  iSvc : Integer;
  iSvcPort : Integer;
  iBind : Integer;
  iPort : Integer;
  LSvc : TIdSoapWSDLService;
  LPort : TIdSoapWSDLServicePort;
  LBind : TIdSoapWSDLBinding;
  LEntry : TPortTypeEntry;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(FWsdl.TestValid(TIdSoapWSDL), ASSERT_LOCATION+': WSDL is not valid');

  For iSvc := 0 To FWsdl.Services.count - 1 Do
    Begin
    LSvc := FWsdl.Services.Objects[iSvc] As TIdSoapWSDLService;
    Assert(LSvc.TestValid(TIdSoapWSDLService), ASSERT_LOCATION+': Svc '+inttostr(iSvc)+' is not valid');
    For iSvcPort := 0 To LSvc.Ports.Count - 1 Do
      Begin
      Try
        LPort := LSvc.Ports.Objects[iSvcPort] As TIdSoapWSDLServicePort;
        Check(LPort.SoapAddress <> '', 'Service '+LSvc.Name+'.'+LPort.Name+' ignored as no SOAP Address was specified');
        iBind := FWsdl.Bindings.IndexOf(LPort.BindingName.Name);
        Check(iBind <> -1, 'Service '+LSvc.Name+'.'+LPort.Name+' ignored as binding could not be found');
        LBind := FWsdl.Bindings.objects[iBind] As TIdSoapWSDLBinding;
        Check(LBind.SoapTransport = ID_SOAP_NS_SOAP_HTTP, 'Service '+LSvc.Name+'.'+LPort.Name+' ignored as Soap:Document is transport type is not supported');
        iPort := FWsdl.PortTypes.IndexOf(LBind.PortType.Name);
        Check(iPort <> -1, 'Service '+LSvc.Name+'.'+LPort.Name+' ignored as Binding PortType not found');
        LEntry := TPortTypeEntry.Create;
        LEntry.FSvc := LSvc;
        LEntry.FBind := LBind;
        LEntry.FPort := FWsdl.PortTypes.Objects[iPort] As TIdSoapWSDLPortType;
        FValidPortTypes.AddObject(LPort.SoapAddress, LEntry);
      Except
        On e:EIdSoapException Do
          Begin
          FComments.Add('* '+e.Message);
          FComments.Add('');
          End
        Else
          Raise;
      End;
      End;
    End;
End;

Procedure TIdSoapWSDLToAdvConvertor.ProcessRPCOperation(AOp: TIdSoapWSDLPortTypeOperation; AOpBind : TIdSoapWSDLBindingOperation; AMethod: TIdSoapITIMethod);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.ProcessRPCOperation';
Var
  i : Integer;
  LMessage : TIdSoapWSDLMessage;
Begin
  Assert(Self.testValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid' );
  Assert(AOp.TestValid(TIdSoapWSDLPortTypeOperation), ASSERT_LOCATION+': Op is not valid');
  Assert(AMethod.TestValid(TIdSoapITIMethod), ASSERT_LOCATION+': method is not valid');

  AMethod.RequestMessageName := AOp.Name;
  AMethod.ResponseMessageName := AOp.Name+'Response';

  i := FWsdl.Messages.IndexOf(AOp.Input.Message.Name);
  Assert(i <> -1, ASSERT_LOCATION+': unable to find input message definition for Operation "'+AOp.Name+'"');
  LMessage := FWsdl.Messages.objects[i] As TIdSoapWSDLMessage;
  If Assigned(AOpBind) Then
    Begin
    ProcessMessageParts(AMethod, LMessage, AOpBind.Input, False);
    End
  Else
    Begin
    ProcessMessageParts(AMethod, LMessage, Nil, False);
    End;

  i := FWsdl.Messages.IndexOf(AOp.output.Message.Name);
  Assert(i <> -1, ASSERT_LOCATION+': unable to find output message definition for Operation "'+AOp.Name+'"');
  LMessage := FWsdl.Messages.objects[i] As TIdSoapWSDLMessage;

  If Assigned(AOpBind) Then
    Begin
    ProcessMessageParts(AMethod, LMessage, AOpBind.OutPut, True);
    End
  Else
    Begin
    ProcessMessageParts(AMethod, LMessage, Nil, True);
    End;
  // no process headers for RPC at the moment
End;

Function TIdSoapWSDLToAdvConvertor.FindRootElement(AMethod : TIdSoapITIMethod; AName : String):TIdSoapWsdlElementDefn;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.FindRootElement';
Var
  i : Integer;
  LMessage : TIdSoapWSDLMessage;
  LPart : TIdSoapWSDLMessagePart;
Begin
  Assert(Self.testValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid' );
  Assert(AMethod.TestValid(TIdSoapITIMethod), ASSERT_LOCATION+': method is not valid');
  Assert(AName <> '', ASSERT_LOCATION+': name is not valid');
  
  i := FWsdl.Messages.IndexOf(AName);
  Assert(i <> -1, ASSERT_LOCATION+': unable to find input message definition for Operation "'+AName+'"');
  LMessage := FWsdl.Messages.objects[i] As TIdSoapWSDLMessage;
  Assert(LMessage.Parts.count = 1, ASSERT_LOCATION+': Operation "'+AMethod.Name+'" is a doc|lit service. The definition for the message "'+AName+'" has more than one part ("'+LMessage.Parts.CommaText+'"). IndySoap does not support this');
  LPart := LMessage.Parts.Objects[0] As TIdSoapWSDLMessagePart;
  Assert(LPart.Element.Name <> '', ASSERT_LOCATION+': Operation "'+AMethod.Name+'" is a doc|lit service but parameter is not an element');
  i := FWsdl.SchemaSection[LPart.Element.Namespace].Elements.IndexOf(LPart.Element.Name);
  Assert(i > -1, ASSERT_LOCATION+': Operation "'+AMethod.Name+'": Element "'+LPart.Element.Name+'" in "'+LPart.Element.Namespace+'" not found');
  Result := FWsdl.SchemaSection[LPart.Element.Namespace].Elements.Objects[i] As TIdSoapWsdlElementDefn;
  Assert(Result.Namespace = LPart.Element.Namespace, ASSERT_LOCATION+': Namespace mismatch internally');
// Disabled 7/7/2003 GDG - no particular reason why this needs to be the case now
//  Assert(result.Namespace = FWsdl.Namespace, 'Operation "'+AMethod.Name+'": Base Element "'+LPart.Element.Name+'" is in the namespace "'+LPart.Element.Namespace+'" which is different to the Interface Namespace "'+FWsdl.Namespace+'". Cannot continue');
End;

Procedure TIdSoapWSDLToAdvConvertor.ProcessDocLitOperation(AOp: TIdSoapWSDLPortTypeOperation; AMethod: TIdSoapITIMethod);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.ProcessDocLitOperation';
Var
  LBaseElement : TIdSoapWsdlElementDefn;
Begin
  Assert(Self.testValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid' );
  Assert(AOp.TestValid(TIdSoapWSDLPortTypeOperation), ASSERT_LOCATION+': Op is not valid');
  Assert(AMethod.TestValid(TIdSoapITIMethod), ASSERT_LOCATION+': method is not valid');

//  ok, we are in document mode? If we are, then the name of the message is the
//  name of the element that is the first part of the message.
//  we have a rule that there can only be one part per message - otherwise what would
//  it''s message name be? that would put it outside the scope of IndySoap.
  LBaseElement := FindRootElement(AMethod, AOp.Input.Message.Name);
  AMethod.RequestMessageName := LBaseElement.Name;
  ProcessDocLitParts(AMethod, LBaseElement, False);

  LBaseElement := FindRootElement(AMethod, AOp.Output.Message.Name);
  AMethod.ResponseMessageName := LBaseElement.Name;
  ProcessDocLitParts(AMethod, LBaseElement, True);
End;

Function TIdSoapWSDLToAdvConvertor.GetOpNamespace(AOp: TIdSoapWSDLPortTypeOperation; ABind : TIdSoapWSDLBinding):String;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.GetOpNamespace';
Var
  i : Integer;
  LBindOp : TIdSoapWSDLBindingOperation;
Begin
  Assert(Self.testValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid' );
  Assert(AOp.TestValid(TIdSoapWSDLPortTypeOperation), ASSERT_LOCATION+': Op is not valid');
  Assert(ABind.TestValid(TIdSoapWSDLBinding), ASSERT_LOCATION+': Bind is not valid');

  i := ABind.Operations.IndexOf(AOp.Name+'|'+AOp.Input.Name+'|'+AOp.Output.Name);
  If i > -1 Then
    Begin
    LBindOp := ABind.Operations.Objects[i] As TIdSoapWSDLBindingOperation;
    If Assigned(LBindOp.Input) Then
      Begin
      Result := LBindOp.Input.SoapNamespace;
      If Assigned(LBindOp.Output) Then
        Begin
        Assert(LBindOp.Input.SoapNamespace = LBindOp.Output.SoapNamespace, ASSERT_LOCATION+': input and output namespaces must be the same');
        End;
      End
    Else
      Begin
      If Assigned(LBindOp.Output) Then
        Begin
        Result := LBindOp.Output.SoapNamespace;
        End
      Else
        Begin
        Result := '';
        End;
      End;
    End
  Else
    Begin
    Result := '';
    End;
End;

Procedure TIdSoapWSDLToAdvConvertor.ProcessSoapHeaders(AMsg: TIdSoapWSDLBindingOperationMessage; AMethod: TIdSoapITIMethod; AHeaderList: TIdSoapITIParamList);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.ProcessSoapHeaders';
Var
  i, j : Integer;
  LHeader : TIdSoapWSDLBindingOperationMessageHeader;
  LParam : TIdSoapITIParameter;
  LMsg : TIdSoapWSDLMessage;
  LPart : TIdSoapWSDLMessagePart;
  aFieldType : TFieldType;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AMsg.TestValid(TIdSoapWSDLBindingOperationMessage), ASSERT_LOCATION+': Msg is not valid');
  Assert(AMethod.TestValid(TIdSoapITIMethod), ASSERT_LOCATION+': Method is not valid');
  Assert(AHeaderList.TestValid(TIdSoapITIParamList), ASSERT_LOCATION+': HeaderList is not valid');

  For i := 0 To AMsg.Headers.count -1 Do
    Begin
    LHeader := AMsg.Headers.Objects[i] As TIdSoapWSDLBindingOperationMessageHeader;
    // ignore: SoapUse, SoapEncodingStyle, SoapNamespace until we have some cause to look at them
    Assert(LHeader.Message.Namespace = FWsdl.Namespace, ASSERT_LOCATION+': namespace problem - looking for a message in namespace "'+LHeader.Message.Namespace+'", but wsdl is in namespace "'+FWsdl.Namespace+'"');
    j := FWsdl.Messages.IndexOf(LHeader.Message.Name);
    Assert(j <> -1, ASSERT_LOCATION+': unable to find header message definition for Operation "'+LHeader.Message.Name+'"');
    LMsg := FWsdl.Messages.objects[j] As TIdSoapWSDLMessage;
    Assert(LMsg.Parts.count = 1, ASSERT_LOCATION+': header "'+LHeader.Message.Name+'" has multiple parts - this is not supported');
    LPart := LMsg.Parts.Objects[0] As TIdSoapWSDLMessagePart;

    LParam := TIdSoapITIParameter.Create(AMethod.ITI, AMethod);
    LParam.Name := ChoosePascalName('', LPart.Name, True);
    LParam.XMLName := LPart.Name;
    If LPart.Element.Name <> '' Then
      Begin
      LParam.NameOfType := AsSymbolName(ProcessElement(AMethod, LPart.Name, AMsg, LPart.Element, aFieldType));
      End
    Else
      Begin
      LParam.NameOfType := AsSymbolName(ProcessType(AMethod, LPart.Name, AMsg, LPart.PartType, aFieldType));
      End;
    LParam.FieldType := aFieldType;
    AHeaderList.AddParam(LParam);
    End;
End;

Procedure TIdSoapWSDLToAdvConvertor.ProcessOperation(AInterface : TIdSoapITIInterface; AOp: TIdSoapWSDLPortTypeOperation; ABind : TIdSoapWSDLBinding);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.ProcessOperation';
Var
  LMethod : TIdSoapITIMethod;
  i : Integer;
  LBindOp : TIdSoapWSDLBindingOperation;
  LName : String;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AOp.TestValid(TIdSoapWSDLPortTypeOperation), ASSERT_LOCATION+': WSDL is not valid');
  Assert(FWsdl.TestValid(TIdSoapWSDL), ASSERT_LOCATION+': WSDL is not valid');
  Assert(FIti.TestValid(TIdSoapITI), ASSERT_LOCATION+': WSDL is not valid');

  LName := ChoosePascalName('', AOp.Name, False);
  If AInterface.Methods.indexof(LName) <> -1 Then
    Begin
    i := 0;
    Repeat
      Inc(i);
      LName := ChoosePascalName('', AOp.Name + inttostr(i), False);
    Until AInterface.Methods.indexof(LName) = -1;
    End;

  LMethod := TIdSoapITIMethod.Create(FIti, AInterface);
  LMethod.CallingConvention := idccStdCall;
  LMethod.Name := LName;
  AInterface.Methods.AddObject(LMethod.Name, LMethod);
  LMethod.Documentation := AOp.Documentation;
  i := ABind.Operations.IndexOf(AOp.Name+'|'+AOp.Input.Name+'|'+AOp.Output.Name);
  If i > -1 Then
    Begin
    LBindOp := ABind.Operations.Objects[i] As TIdSoapWSDLBindingOperation;
    LMethod.SoapAction := LBindOp.SoapAction;
    If (LBindOp.SoapStyle = sbsDocument) Or (LBindOp.Input.SoapUse = sesLiteral) Then
      Begin
      LMethod.EncodingMode := semDocument;
      End;
    ProcessSoapHeaders(LBindOp.Input, LMethod, LMethod.Headers);
    ProcessSoapHeaders(LBindOp.Output, LMethod, LMethod.RespHeaders);
    End
  Else
    Begin
    LBindOp := Nil;
    End;
  If Assigned(LBindOp) And ((LBindOp.Input.DimeLayout <> '') Or (LBindOp.Output.DimeLayout <> '')) Then
    Begin
    AInterface.AttachmentType := iatDime;
    End;
  If LMethod.EncodingMode = semDocument Then
    Begin
    ProcessDocLitOperation(AOp, LMethod);
    End
  Else
    Begin
    ProcessRPCOperation(AOp, LBindOp, LMethod);
    End;
  If LMethod.ResultType <> '' Then
    Begin
    LMethod.MethodKind := mkFunction;
    End
  Else
    Begin
    LMethod.MethodKind := mkProcedure;
    End;
End;

Procedure TIdSoapWSDLToAdvConvertor.ProcessMessageParts(AMethod: TIdSoapITIMethod; AMessage: TIdSoapWSDLMessage; AOp : TIdSoapWSDLBindingOperationMessage; AIsOutput: Boolean);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.ProcessMessageParts';
Var
  i : Integer;
  LPart : TIdSoapWSDLMessagePart;
  LType : TSymbolName;
  LParam : TIdSoapITIParameter;
  LPascalName : String;
  aFieldType : TFieldType;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AMethod.TestValid(TIdSoapITIMethod), ASSERT_LOCATION+': WSDL is not valid');
  Assert(AMessage.TestValid(TIdSoapWSDLMessage), ASSERT_LOCATION+': WSDL is not valid');
  // no check AIsOutput

  For i := 0 To AMessage.Parts.count -1 Do
    Begin
    LPart := AMessage.Parts.Objects[i] As TIdSoapWSDLMessagePart;
    If LPart.Element.Name <> '' Then
      Begin
      LType := AsSymbolName(ProcessElement(AMethod, LPart.Name, AOp, LPart.Element, aFieldType));
      End
    Else
      Begin
      LType := AsSymbolName(ProcessType(AMethod, LPart.Name, AOp, LPart.PartType, aFieldType));
      End;
    If AIsOutput Then
      Begin
      If (i = 0) And (AnsiSameText(Copy(LPart.Name, Length(LPart.Name)-5, 6), 'return') Or AnsiSameText(Copy(LPart.Name, Length(LPart.Name)-6, 7), 'result')) Then
        Begin
        AMethod.ResultType := LType;
        AMethod.ResultName := LPart.Name;
        AMethod.ResultFieldType := aFieldType;
        End
      Else
        Begin
        LPascalName := ChoosePascalName('', LPart.Name, True);
        If AMethod.Parameters.indexof(LPascalName) = -1 Then
          Begin
          LParam := TIdSoapITIParameter.Create(FIti, AMethod);
          LParam.XMLName := LPart.Name;
          AMethod.Parameters.AddObject(LPascalName, LParam);
          LParam.Name := LPascalName;
          LParam.ParamFlag := pfOut;
          LParam.NameOfType := LType;
          LParam.FieldType := aFieldType;
          End
        Else
          Begin
          LParam := AMethod.Parameters.ParamByName[LPascalName];
          Assert(LParam.NameOfType = LType, ASSERT_LOCATION+': different types in and out for parameter "'+AMethod.Name+'.'+LPascalName+'"');
          LParam.ParamFlag := pfVar;
          End;
        End;
      End
    Else
      Begin
      LParam := TIdSoapITIParameter.Create(FIti, AMethod);
      LParam.XMLName := LPart.Name;
      LPascalName := ChoosePascalName('', LPart.Name, True);
      AMethod.Parameters.AddObject(LPascalName, LParam);
      LParam.Name := LPascalName;
      LParam.ParamFlag := pfConst;
      LParam.NameOfType := LType;
      LParam.FieldType := aFieldType;
      End;
    End;
End;

Procedure TIdSoapWSDLToAdvConvertor.ProcessDocLitParts(AMethod: TIdSoapITIMethod; ABaseElement: TIdSoapWSDLElementDefn; AIsOutput: Boolean);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.ProcessDocLitParts';
Var
  i : Integer;
  LName : String;
  LPascalName : String;
  LType : TSymbolname;
  LComplexType : TIdSoapWsdlComplexType;
  LPart : TIdSoapWSDLAbstractType;
  AElement : TIdSoapWSDLElementDefn;
  LParam : TIdSoapITIParameter;
  aFieldType : TFieldType;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AMethod.TestValid(TIdSoapITIMethod), ASSERT_LOCATION+': WSDL is not valid');
  Assert(ABaseElement.TestValid(TIdSoapWSDLElementDefn), ASSERT_LOCATION+': WSDL is not valid');
  // no check AIsOutput

  Assert(ABaseElement.TypeDefn.TestValid(TIdSoapWsdlComplexType), ASSERT_LOCATION+': The base element "'+ABaseElement.Name+'" must be a complex type in doc|lit');
  LComplexType := ABaseElement.TypeDefn As TIdSoapWsdlComplexType;
  For i := 0 To LComplexType.Elements.count -1 Do
    Begin
    LPart := LComplexType.Elements.Objects[i] As TIdSoapWSDLAbstractType;
    If LPart Is TIdSoapWsdlElementDefn Then
      Begin
      Assert((LPart As TIdSoapWsdlElementDefn).IsReference, ASSERT_LOCATION+': expected a reference');
      AElement := FWsdl.GetElement((LPart As TIdSoapWsdlElementDefn).TypeInfo);
      Assert(AElement.TestValid(TIdSoapWSDLElementDefn), ASSERT_LOCATION+': Referenced Element is not valid');
      Assert(AElement.TypeInfo.Name <> '', ASSERT_LOCATION+': Referenced Element has no type');
      LType := AsSymbolName(ProcessType(AMethod, '', Nil, AElement.TypeInfo, aFieldType));
      LName := AElement.Name;
      End
    Else If LPart Is TIdSoapWsdlSimpleType Then
      Begin
      If (LPart.MaxOccurs = 'unbounded') Or (LPart.MaxOccurs = '*') Then
        Begin
        LType := AsSymbolName(CreateArrayType(AMethod, Nil, (LPart As TIdSoapWsdlSimpleType).Info));
        End
      Else
        Begin
        LType := AsSymbolName(ProcessType(AMethod, '', Nil, (LPart As TIdSoapWsdlSimpleType).Info, aFieldType));
        End;
      LName := LPart.Name;
      End
    Else
      Raise EIdSoapRequirementFail.Create(ASSERT_LOCATION+': unexpected type '+LPart.ClassName);

    LPascalName := ChoosePascalName('', LName, True);
    If AIsOutput Then
      Begin
      If (i = 0) And (AnsiSameText(LName, 'return') Or AnsiSameText(LName, 'result')) Or AnsiSameText(LName, AMethod.Name+'result') Then
        Begin
        AMethod.ResultType := LType;
        AMethod.ResultName := LPart.Name;
        AMethod.ResultFieldType := aFieldType;
        End
      Else
        Begin
        If AMethod.Parameters.indexof(LPascalName) = -1 Then
          Begin
          LParam := TIdSoapITIParameter.Create(FIti, AMethod);
          LParam.XMLName := LName;
          AMethod.Parameters.AddObject(LPascalName, LParam);
          LParam.Name := LPascalName;
          LParam.ParamFlag := pfOut;
          LParam.NameOfType := LType;
          LParam.FieldType := aFieldType;
          End
        Else
          Begin
          LParam := AMethod.Parameters.ParamByName[LPascalName];
          Assert(LParam.NameOfType = LType, ASSERT_LOCATION+': different types in and out for parameter "'+AMethod.Name+'.'+LPascalName+'"');
          LParam.ParamFlag := pfVar;
          End;
        End;
      End
    Else
      Begin
      LParam := TIdSoapITIParameter.Create(FIti, AMethod);
      LParam.XMLName := LName;
      AMethod.Parameters.AddObject(LPascalName, LParam);
      LParam.Name := LPascalName;
      LParam.ParamFlag := pfConst;
      LParam.NameOfType := LType;
      LParam.FieldType := aFieldType;
      End;
    End;
End;

Function TIdSoapWSDLToAdvConvertor.TypeIsArray(AType: TQName): Boolean;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.TypeIsArray';
Var
  i : Integer;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AType.TestValid(TQName), ASSERT_LOCATION+': self is not valid');

  If AType.NameSpace = ID_SOAP_NS_SCHEMA Then
    Begin
    Result := False;
    End
  Else
    Begin
    i := FDefinedTypes.IndexOf(AType.NameSpace+#1+AType.Name);
    Assert(i <> -1, ASSERT_LOCATION+': Type '+AType.Name+' not declared yet');
    Result := (FDefinedTypes.objects[i] As TIdSoapWSDLPascalFragment).FTypeType = idttList;
    End;
End;

Function TIdSoapWSDLToAdvConvertor.ProcessElement(AMethod: TIdSoapITIMethod; AName: String; AOp : TIdSoapWSDLBindingOperationMessage; AElement: TQName; Var aFieldType : TFieldType): String;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.ProcessType';
Var
  i : Integer;
  LType : TIdSoapWsdlElementDefn;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AMethod.TestValid(TIdSoapITIMethod), ASSERT_LOCATION+': self is not valid');
  Assert(AElement.TestValid(TQName), ASSERT_LOCATION+': self is not valid');

  i := FWsdl.SchemaSection[AElement.NameSpace].Elements.IndexOf(AElement.Name);
  Assert(i <> -1, ASSERT_LOCATION+': Element '+AElement.Name+' in "'+AElement.NameSpace+'" not declared in the WSDL');
  LType := FWsdl.SchemaSection[AElement.NameSpace].Elements.Objects[i] As TIdSoapWsdlElementDefn;
  If LType.TypeInfo.Name <> '' Then
    Begin
    Result := ProcessType(AMethod, AName, AOp, LType.TypeInfo, aFieldType);
    End
  Else
    Begin
    Result := 'not done yet'
    End;
End;

Function TIdSoapWSDLToAdvConvertor.GetEnumName(AEnumType, AEnumValue : String):String;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.GetEnumName';
Var
  LModified : Boolean;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(isXmlName(AEnumType), 'Enum Type "'+AEnumType+'" not valid');
  Assert(isXmlName(AEnumValue), 'Enum Value "'+AEnumValue+'" not valid');


  Result := Copy(AEnumType, 2, $FF)+AEnumValue;
  LModified := False;
  While (FUsedPascalIDs.IndexOf(Result) > -1) Or (FReservedPascalNames.Indexof(Result) > -1) Do
    Begin
    If LModified Then
      Begin
      If Result[Length(Result)] = '_' Then
        Begin
        Result := Result + '1';
        End
      Else
        Begin
        If Result[Length(Result)] = '9' Then
          Begin
          Result[Length(Result)] := 'A';
          End
        Else
          Begin
          Assert(Result[Length(Result)] < 'Z', ASSERT_LOCATION+': Ran out of space generating an alternate representation for the name "'+AEnumType+'.'+AEnumValue+'"');
          Result[Length(Result)] := Chr(ord(Result[Length(Result)])+1);
          End;
        End;
      End
    Else
      Begin
      Result := Result + '_';
      LModified := True;
      End;
    End;
  FUsedPascalIDs.Add(Result);
End;

Function TIdSoapWSDLToAdvConvertor.ProcessType(AMethod : TIdSoapITIMethod; AName: String; AOp : TIdSoapWSDLBindingOperationMessage; AType: TQName; Var aFieldType : TFieldType):String;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.ProcessType';
Var
  i : Integer;
  LType : TIdSoapWSDLAbstractType;
  LTypeCode : TIdSoapWSDLPascalFragment;
  LImpl : String;
  LReg : String;
  LAncestor : String;
  LName : String;
  LPascalName : String;
  aInnerFieldType : TFieldType;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AType.TestValid(TQName), ASSERT_LOCATION+': self is not valid');

  If (AType.NameSpace = ID_SOAP_NS_SCHEMA) Or (AType.NameSpace = ID_SOAP_NS_SOAPENC) Then
    Begin
    aFieldType := ftSimple;
    // if it's a type in the schema namespace, then we should be able to map it directly
    // we also make this rule for the SOAP encoding namespace, since the bulk of
    // types in that namespace are simply extensions of schema types with id and href
    // added, and we don't care about that.
    // this does mean that we will serialise using XSD instead of the soap namespace.
    // if this is a problem, then we will deal with it then
    If AType.NameSpace = ID_SOAP_NS_SOAPENC Then
      Begin
      Result := String(GetTypeForSoapType(AType.Name)^.Name);
      End
    Else
      Begin
      Result := String(GetTypeForSchemaType(AType.Name)^.Name);
      End;
    If Result = 'TIdSoapDateTime' Then
      Result := 'TDateTime';
    If Result = 'TStream' Then
      Begin
      aFieldType := ftClass;
      If Assigned(AOp) And (AOp.MimeParts.IndexOf(AName) > -1) Then
        Begin
        Result := 'TIdSoapAttachment';
        End
      Else
        Result := 'TAdvBuffer';
      AddUnit('AdvBuffers', True);
      End;
    End
  Else
    Begin
    i := FWsdl.SchemaSection[AType.NameSpace].Types.IndexOf(AType.Name);
    Assert(i <> -1, ASSERT_LOCATION+': Type '+AType.Name+' in "'+AType.NameSpace+'" not declared in the WSDL');
    LType := FWsdl.SchemaSection[AType.NameSpace].Types.Objects[i] As TIdSoapWSDLAbstractType;
    If FDefinedTypes.IndexOf(AType.Namespace+#1+AType.Name) > -1 Then
      Begin
      LTypeCode := FDefinedTypes.objects[FDefinedTypes.IndexOf(AType.Namespace+#1+AType.Name)] As TIdSoapWSDLPascalFragment;
      aFieldType := lTypeCode.FFieldType;
      Result := LTypeCode.FPascalName;
      End
    Else
      Begin
      LPascalName := ChoosePascalNameForType(AType.Name);
//      If (LPascalName <> AType.Name) Or (AType.Namespace <> FWsdl.Namespace) Then
//        Begin
//        LTypeComment := 'Type: '+ LPascalName+' = ';
//        If (LPascalName <> AType.Name) Then
//          Begin
//          LTypeComment := LTypeComment + AType.Name+' ';
//          End;
//        If (AType.Namespace <> FWsdl.Namespace) Then
//          Begin
//          LTypeComment := LTypeComment + 'in '+ AType.Namespace;
//          End;
//        FNameAndTypeComments.Add(LTypeComment);
//        End;
      Result := LPascalName;
      LTypeCode := TIdSoapWSDLPascalFragment.Create;
      LTypeCode.FFieldType := ftClass;
      LTypeCode.FIncludeInPascal := FExemptTypes.IndexOf('{'+AType.Namespace+'}'+AType.Name) = -1;
      FDefinedTypes.AddObject(AType.Namespace+#1+AType.Name, LTypeCode);
      LTypeCode.FPascalName := LPascalName;
      If LType Is TIdSoapWsdlSimpleType Then
        Begin
        // check for very special case:
        //    - the type is base64binary
        //    - a href atttribute has been added
        //    - The type of that is xsd:anyURI
        //    - we are in doc|lit mode.
        // in this case, it's a reference to an attachment
        If  ((LType As TIdSoapWsdlSimpleType).Info.Name = 'base64Binary') And
            Assigned((LType As TIdSoapWsdlSimpleType).Attribute['href']) And
            ((LType As TIdSoapWsdlSimpleType).Attribute['href'].Namespace = ID_SOAP_NS_SCHEMA_2001) And
            ((LType As TIdSoapWsdlSimpleType).Attribute['href'].Name = 'anyURI') And
            (AMethod.EncodingMode = semDocument) Then
          Begin
          LTypeCode.FTypeType := idttSimple;
          LTypeCode.FCode := '  '+Result+' = type !TIdSoapAttachment;'+EOL_WINDOWS;
          End
        Else
          Begin
          LTypeCode.FTypeType := idttSimple;
          If (LType As TIdSoapWsdlSimpleType).Info.NameSpace = ID_SOAP_NS_SOAPENC Then
            Begin
            LTypeCode.FCode := '  '+Result+' = type '+String(GetTypeForSoapType((LType As TIdSoapWsdlSimpleType).Info.Name)^.Name)+';'+EOL_WINDOWS;
            End
          Else
            Begin
            LTypeCode.FCode := '  '+Result+' = type '+String(GetTypeForSoapType((LType As TIdSoapWsdlSimpleType).Info.Name)^.Name)+';'+EOL_WINDOWS;
            End;
          End;
        End
      Else If LType Is TIdSoapWsdlSetType Then
        Begin
        LTypeCode.FTypeType := idttSet;
        LTypeCode.FCode := '  '+Result+' = Set of ' + ProcessType(AMethod, '', Nil, (LType As TIdSoapWsdlSetType).Enum, aInnerFieldType)+';'+EOL_WINDOWS;
        End
      Else If LType Is TIdSoapWsdlEnumeratedType Then
        Begin
        Assert((LType As TIdSoapWsdlEnumeratedType).Values.count > 0, ASSERT_LOCATION+': unexpected condition, no values in enumerated type');
        LTypeCode.FFieldType := ftEnum;
        LTypeCode.FTypeType := idttSimple;
        LTypeCode.FCode := '  '+Result+' = (' +GetEnumName(Result, (LType As TIdSoapWsdlEnumeratedType).Values[0]);
        For i := 1 To (LType As TIdSoapWsdlEnumeratedType).Values.count - 1 Do
          Begin
          LTypeCode.FCode := LTypeCode.FCode + ', '+GetEnumName(Result, (LType As TIdSoapWsdlEnumeratedType).Values[i]);
          End;
        LTypeCode.FCode := LTypeCode.FCode + ');'+EOL_WINDOWS;
        LTypeCode.FDecl := '  '+Copy(Result, 2, $FF)+'NameArray : Array ['+Result+'] of String = (''' +(LType As TIdSoapWsdlEnumeratedType).Values[0]+'''';
        For i := 1 To (LType As TIdSoapWsdlEnumeratedType).Values.count - 1 Do
          Begin
          LTypeCode.FDecl := LTypeCode.FDecl + ', '''+(LType As TIdSoapWsdlEnumeratedType).Values[i]+'''';
          End;
        LTypeCode.FDecl := LTypeCode.FDecl + ');'+EOL_WINDOWS;
        End
      Else If LType Is TIdSoapWsdlArrayType Then
        Begin
        LTypeCode.FTypeType := idttList;
        LName := ProcessType(AMethod, AName, AOp, (LType As TIdSoapWsdlArrayType).TypeName, aInnerFieldType);
        // '+Result+' = array of '+ LName +';'+EOL_WINDOWS;

        LTypeCode.FCode :=
          '  '+LName+'List = Class(TAdvPersistentList)'+EOL_WINDOWS+
          '    Private'+EOL_WINDOWS+
          '      Function GetElementByIndex(Const iIndex : Integer) : '+LName+';'+EOL_WINDOWS+
          '      Procedure SetElementByIndex(Const iIndex : Integer; Const oValue : '+LName+');'+EOL_WINDOWS+
          '    Protected'+EOL_WINDOWS+
          '      Function ItemClass : TAdvObjectClass; Override;'+EOL_WINDOWS+
          '      Function Get(Const aValue : Integer) : '+LName+'; Reintroduce;'+EOL_WINDOWS+
          '    Public'+EOL_WINDOWS+
          '      Function Link : '+LName+'List; '+EOL_WINDOWS+
          '      Function Clone : '+LName+'List; '+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          '      Function New : '+LName+'; Reintroduce;'+EOL_WINDOWS+
          '      Property ElementByIndex[Const iIndex : Integer] : '+LName+' Read GetElementByIndex Write SetElementByIndex; Default;'+EOL_WINDOWS+
          '  End;'+EOL_WINDOWS+EOL_WINDOWS;

        End
      Else If LType Is TIdSoapWsdlComplexType Then
        Begin
        LTypeCode.FTypeType := idttClass;
        LTypeCode.FDecl := '  '+Result+' = Class;'+EOL_WINDOWS;
        LTypeCode.FCode := WriteComplexType(AMethod, AType, Result, LType As TIdSoapWsdlComplexType, AOp, LAncestor, LImpl, LReg);
        LTypeCode.FAncestor := LAncestor;
        LTypeCode.FImpl := LImpl;
        End
      Else
        Begin
        Assert(False, ASSERT_LOCATION+': Unknown WSDL type Class '+LType.ClassName);
        End;
      aFieldType := LTypeCode.FFieldType;
      End;
    End;
End;


Procedure TIdSoapWSDLToAdvConvertor.WriteClientImpl();
Var
  i, j : Integer;
  LIntf : TIdSoapITIInterface;
Begin
  For i := 0 To FITI.Interfaces.count - 1 Do
  Begin
    LIntf := FITI.Interfaces.IFace[i];
    writeln('{ '+LIntf.Name+' }');
    writeln('');
    writeln('Constructor '+LIntf.Name+'.Create;');
    writeln('Begin');
    writeln('  Inherited;');
    If copy(LIntf.SoapAddress, 1, 5) = 'https' Then
      writeln('  UseWinInet := true;');
    writeln('  Address := '''+LIntf.SoapAddress+''';');
    writeln('  Namespace := '''+LIntf.Namespace+''';');
    writeln('End;');
    writeln('');
    writeln('');
    For j := 0 To LIntf.Methods.count - 1 Do
    Begin
      WriteMethodImpl(LIntf, LIntf.Methods.objects[j] As TIdSoapITIMethod, '' {LSoapAction});
    End;
  End;
End;


Procedure TIdSoapWSDLToAdvConvertor.WriteITI;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.WriteITI';
Var
  i, j : Integer;
  LIntf : TIdSoapITIInterface;
  LSoapAction : String;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(FITI.TestValid(TIdSoapITI), ASSERT_LOCATION+': self is not valid');

//  LSoapAction := '';
  For i := 0 To FITI.Interfaces.count - 1 Do
    Begin
    LIntf := FITI.Interfaces.IFace[i];
//    writeln('type');
//    writeln('  {Soap Address for this Interface: '+LIntf.SoapAddress+'}');
    writeln('  '+LIntf.Name+' = Class (TAdvWebServiceClient)');
    writeln('    Public');
    writeln('      Constructor Create; Override;');
(*    Write('       {!Namespace: '+LIntf.Namespace);
    If (LIntf.Methods.count > 0) And ((LIntf.Methods.objects[0] As TIdSoapITIMethod).SoapAction <> '') Then
      Begin
      LSoapAction := (LIntf.Methods.objects[0] As TIdSoapITIMethod).SoapAction;
      Writeln(';');
      Write('         SoapAction: '+LSoapAction);
      End;
    If AllMethodsAreDocument(LIntf) Then
      Begin
      Writeln(';');
      Write('         Encoding: Document');
      FDefaultEncoding := semDocument;
      End
    Else
      Begin
      FDefaultEncoding := semRPC;
      End;
    If LIntf.AttachmentType = iatDime Then
      Begin
      Writeln(';');
      Write('         Attachments: Dime');
      End;
    Writeln('}');
    If LIntf.Documentation <> '' Then
      Begin
      Writeln('      {&'+LIntf.Documentation+'}');
      End;
      *)
    For j := 0 To LIntf.Methods.count - 1 Do
      Begin
      WriteMethod(LIntf.Methods.objects[j] As TIdSoapITIMethod, LSoapAction);
      End;
    writeln('  End;');
    writeln('');
        (*
    If FAddFactory  Then
      Begin
      If (LIntf.SoapAddress = MULTIPLE_ADDRESSES) Or Not (AnsiSameText('http', Copy(LIntf.SoapAddress, 1, 4))) Then
        Begin
        Writeln('Function Get'+LIntf.Name+'(AClient : TIdSoapBaseSender) : '+LIntf.Name+';');
        Writeln('');
        FFactoryText := FFactoryText +
          'Function Get'+LIntf.Name+'(AClient : TIdSoapBaseSender) : '+LIntf.Name+';'+EOL_WINDOWS+
          'Begin'+EOL_WINDOWS+
          '  result := IdSoapD4Interface(AClient) as '+LIntf.Name+';'+EOL_WINDOWS+
          'End;'+EOL_WINDOWS+
          ''+EOL_WINDOWS;
        End
      Else
        Begin
        Writeln('Function Get'+LIntf.Name+'(AClient : TIdSoapBaseSender; ASetUrl : Boolean = true) : '+LIntf.Name+';');
        Writeln('');
        FFactoryText := FFactoryText +
          'Function Get'+LIntf.Name+'(AClient : TIdSoapBaseSender; ASetUrl : Boolean = true) : '+LIntf.Name+';'+EOL_WINDOWS+
          'Begin'+EOL_WINDOWS+
          '  if ASetURL and (AClient is TIdSoapWebClient) then'+EOL_WINDOWS+
          '    Begin'+EOL_WINDOWS+
          '    (AClient as TIdSoapWebClient).SoapURL := '''+LIntf.SoapAddress+''';'+EOL_WINDOWS+
          '    End;'+EOL_WINDOWS+
          '  result := IdSoapD4Interface(AClient) as '+LIntf.Name+';'+EOL_WINDOWS+
          'End;'+EOL_WINDOWS+
          ''+EOL_WINDOWS;
        End;
      End;   *)
    End;
End;

Function AdvType(Const s : TSymbolName):String;
Begin
  result := string(s);
  if SameText(result, 'Comp') Then
    result := 'int64'
  Else if SameText(result, 'Double') Then
    result := 'Extended'
End;


Procedure TIdSoapWSDLToAdvConvertor.WriteMethod(AMeth: TidSoapITIMethod; ADefSoapAction : String);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.WriteMethod';
Var
  i : Integer;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AMeth.TestValid(TidSoapITIMethod), ASSERT_LOCATION+': self is not valid');

  Write('      ');
  If AMeth.ResultType <> '' Then
    Begin
    Write('Function  ');
    End
  Else
    Begin
    Write('Procedure ');
    End;
  Write(AMeth.Name);
  If AMeth.Parameters.count > 0 Then
    Begin
    Write('('+DescribeParam(AMeth.Parameters.Param[0]));
    For i := 1 To AMeth.Parameters.count - 1 Do
      Begin
      Write('; '+DescribeParam(AMeth.Parameters.Param[i]));
      End;
    Write(')');
    End;
  If AMeth.ResultType <> '' Then
    Begin
    Write(' : ');
    Write(AdvType(AMeth.ResultType));
    End;
  WriteLn(';');
(*  If (AMeth.RequestMessageName <> AMeth.Name) Or (AMeth.ResponseMessageName <> AMeth.Name+'Response') Or
     (AMeth.SoapAction <> ADefSoapAction) Or (AMeth.EncodingMode <> FDefaultEncoding) Or
     (AMeth.Headers.Count > 0) Or (AMeth.RespHeaders.Count > 0) Then
    Begin
    Write('      {!');
    If (AMeth.RequestMessageName <> AMeth.Name) Then
      Begin
      Write('Request: '+AMeth.RequestMessageName+'; ');
      End;
    If (AMeth.ResponseMessageName <> AMeth.Name+'Response') Then
      Begin
      Write('Response: '+AMeth.ResponseMessageName+'; ');
      End;
    If (AMeth.SoapAction <> ADefSoapAction) Then
      Begin
      Write('SoapAction: '+AMeth.SoapAction+'; ');
      End;
    If AMeth.EncodingMode <> FDefaultEncoding Then
      Begin
      Write('Encoding: '+Copy(IdEnumToString(TypeInfo(TIdSoapEncodingMode), ord(AMeth.EncodingMode)), 4, $FF)+'; ');
      End;
    For i := 0 To AMeth.Headers.Count - 1 Do
      Begin
      Write('Header: '+ AMeth.Headers.Param[i].Name+' = '+ AMeth.Headers.Param[i].NameOfType +'; ');
      End;
    For i := 0 To AMeth.RespHeaders.Count - 1 Do
      Begin
      Write('RespHeader: '+ AMeth.RespHeaders.Param[i].Name+' = '+ AMeth.RespHeaders.Param[i].NameOfType +'; ');
      End;
    writeln('}');
    End;
  If AMeth.Documentation <> '' Then
    Begin
    Writeln('      {&'+AMeth.Documentation+'}');
    End;    *)
End;

Procedure TIdSoapWSDLToAdvConvertor.WriteMethodImpl(aIntf : TIdSoapITIInterface; AMeth: TidSoapITIMethod; ADefSoapAction : String);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.WriteMethod';
Var
  i : Integer;
  oParam : TIdSoapITIParameter;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AMeth.TestValid(TidSoapITIMethod), ASSERT_LOCATION+': self is not valid');

  If AMeth.ResultType <> '' Then
    Begin
    Write('Function  ');
    End
  Else
    Begin
    Write('Procedure ');
    End;
  Write(aIntf.Name+'.'+AMeth.Name);
  If AMeth.Parameters.count > 0 Then
    Begin
    Write('('+DescribeParam(AMeth.Parameters.Param[0]));
    For i := 1 To AMeth.Parameters.count - 1 Do
      Begin
      Write('; '+DescribeParam(AMeth.Parameters.Param[i]));
      End;
    Write(')');
    End;
  If AMeth.ResultType <> '' Then
    Begin
    Write(' : ');
    Write(AdvType(AMeth.ResultType));
    End;
  WriteLn(';');
  Writeln('Var');
  Writeln('  oIn : '+aIntf.Name+'_'+AMeth.Name+'_Params_In;');
  Writeln('  oOut : '+aIntf.Name+'_'+AMeth.Name+'_Params_Out;');
  Writeln('Begin');
  Writeln('  oIn := '+aIntf.Name+'_'+AMeth.Name+'_Params_In.Create;');
  Writeln('  Try');
  Writeln('    oOut := '+aIntf.Name+'_'+AMeth.Name+'_Params_Out.Create;');
  Writeln('    Try');
  For i := 0 To AMeth.Parameters.count - 1 Do
  Begin
    oParam := AMeth.Parameters.Param[i];
    If oParam.ParamFlag In [pfVar, pfConst, pfReference, pfAddress] Then
    Begin
      If oParam.FieldType = ftClass Then
        Writeln('      oIn.'+oParam.Name+' := '+oParam.Name+'.Link;')
      Else
        Writeln('      oIn.'+oParam.Name+' := '+oParam.Name+';');
    End;
  End;
  Writeln('      Execute('''+AMeth.RequestMessageName+''', '''+AMeth.SoapAction+''', oIn, oOut);');

  For i := 0 To AMeth.Parameters.count - 1 Do
  Begin
    oParam := AMeth.Parameters.Param[i];
    If oParam.ParamFlag In [pfVar, pfOut] Then
    Begin
      If oParam.FieldType = ftClass Then
        Writeln('      '+oParam.Name+' := oOut.'+oParam.Name+'.Link;')
      Else
        Writeln('      '+oParam.Name+' := oOut.'+oParam.Name+';');
    End;
  End;

  If AMeth.ResultType <> '' Then
    If AMeth.ResultFieldType = ftClass Then
        Writeln('      Result := oOut.Result.Link;')
      Else
        Writeln('      Result := oOut.Result;');

  Writeln('    Finally');
  Writeln('      oOut.Free;');
  Writeln('    End;');
  Writeln('  Finally');
  Writeln('    oIn.Free;');
  Writeln('  End;');
  Writeln('End;');
  Writeln('');
  Writeln('');
(*  If (AMeth.RequestMessageName <> AMeth.Name) Or (AMeth.ResponseMessageName <> AMeth.Name+'Response') Or
     (AMeth.SoapAction <> ADefSoapAction) Or (AMeth.EncodingMode <> FDefaultEncoding) Or
     (AMeth.Headers.Count > 0) Or (AMeth.RespHeaders.Count > 0) Then
    Begin
    Write('      {!');
    If (AMeth.RequestMessageName <> AMeth.Name) Then
      Begin
      Write('Request: '+AMeth.RequestMessageName+'; ');
      End;
    If (AMeth.ResponseMessageName <> AMeth.Name+'Response') Then
      Begin
      Write('Response: '+AMeth.ResponseMessageName+'; ');
      End;
    If (AMeth.SoapAction <> ADefSoapAction) Then
      Begin
      Write('SoapAction: '+AMeth.SoapAction+'; ');
      End;
    If AMeth.EncodingMode <> FDefaultEncoding Then
      Begin
      Write('Encoding: '+Copy(IdEnumToString(TypeInfo(TIdSoapEncodingMode), ord(AMeth.EncodingMode)), 4, $FF)+'; ');
      End;
    For i := 0 To AMeth.Headers.Count - 1 Do
      Begin
      Write('Header: '+ AMeth.Headers.Param[i].Name+' = '+ AMeth.Headers.Param[i].NameOfType +'; ');
      End;
    For i := 0 To AMeth.RespHeaders.Count - 1 Do
      Begin
      Write('RespHeader: '+ AMeth.RespHeaders.Param[i].Name+' = '+ AMeth.RespHeaders.Param[i].NameOfType +'; ');
      End;
    writeln('}');
    End;
  If AMeth.Documentation <> '' Then
    Begin
    Writeln('      {&'+AMeth.Documentation+'}');
    End;    *)
End;


Function TIdSoapWSDLToAdvConvertor.DescribeParam(AParam: TIdSoapITIParameter): String;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.DescribeParam';
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AParam.TestValid(TIdSoapITIParameter), ASSERT_LOCATION+': self is not valid');

  Result := AParam.Name +' : '+AdvType(AParam.NameOfType);
  If AParam.ParamFlag = pfVar Then
    Begin
    Result := 'var '+Result;
    End
  Else If AParam.ParamFlag = pfOut Then
    Begin
    Result := 'out '+Result;
    End
  Else
    Begin
    Result := 'Const '+Result;
    End;
End;

Function TIdSoapWSDLToAdvConvertor.CreateArrayType(AMethod : TIdSoapITIMethod; AOp : TIdSoapWSDLBindingOperationMessage; ABaseType: TQName) : String;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.CreateArrayType';
Var
  LTypeCode : TIdSoapWSDLPascalFragment;
  AName : String;
  LTypeName : String;
  aFieldType : TFieldType;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AMethod.TestValid(TIdSoapITIMethod), ASSERT_LOCATION+': self is not valid');
  Assert(ABaseType.TestValid(TQName), ASSERT_LOCATION+': self is not valid');

  If AnsiSameText(ABaseType.Name, 'String') Then
    Begin
    Result := 'TAdvStringList';
    End
  Else If AnsiSameText(ABaseType.Name, 'Integer') Then
    Begin
    Result := 'TAdvIntegerList';
    End
  Else
    Begin
    AName := ABaseType.Name + 'List';
    If FDefinedTypes.IndexOf(ABaseType.Namespace+#1+AName) > -1 Then
      Begin
      LTypeCode := FDefinedTypes.objects[FDefinedTypes.IndexOf(ABaseType.Namespace+#1+AName)] As TIdSoapWSDLPascalFragment;
      Result := LTypeCode.FPascalName;
      End
    Else
      Begin
      LTypeName := ProcessType(AMethod, '', AOp, ABaseType, aFieldType);
      LTypeCode := TIdSoapWSDLPascalFragment.Create;
      LTypeCode.FPascalName := ChoosePascalNameForType(AName);
(*      If (LTypeCode.FPascalName <> AName) Or (ABaseType.Namespace <> FWsdl.Namespace) Then
        Begin
        LTypeComment := 'Type: '+ LTypeCode.FPascalName+' = ';
        If (LTypeCode.FPascalName <> AName) Then
          Begin
          LTypeComment := LTypeComment + AName+' ';
          End;
        If (ABaseType.Namespace <> FWsdl.Namespace) Then
          Begin
          LTypeComment := LTypeComment + 'in '+ ABaseType.Namespace;
          End;
//        FNameAndTypeComments.Add(LTypeComment);
        End;          *)
      FDefinedTypes.AddObject(ABaseType.Namespace+#1+AName, LTypeCode);
      Result := LTypeCode.FPascalName;
      LTypeCode.FTypeType := idttList;

        LTypeCode.FCode :=
          '  '+LTypeName+'List = Class(TAdvPersistentList)'+EOL_WINDOWS+
          '    Private'+EOL_WINDOWS+
          '      Function GetElementByIndex(Const iIndex : Integer) : '+LTypeName+';'+EOL_WINDOWS+
          '      Procedure SetElementByIndex(Const iIndex : Integer; Const oValue : '+LTypeName+');'+EOL_WINDOWS+
          '    Protected'+EOL_WINDOWS+
          '      Function ItemClass : TAdvObjectClass; Override;'+EOL_WINDOWS+
          '      Function Get(Const aValue : Integer) : '+LTypeName+'; Reintroduce; '+EOL_WINDOWS+
          '    Public'+EOL_WINDOWS+
          '      Function Link : '+LTypeName+'List; '+EOL_WINDOWS+
          '      Function Clone : '+LTypeName+'List; '+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          '      Function New : '+LTypeName+'; Reintroduce; '+EOL_WINDOWS+
          '      Property ElementByIndex[Const iIndex : Integer] : '+LTypeName+' Read GetElementByIndex Write SetElementByIndex; Default;'+EOL_WINDOWS+
          '  End;'+EOL_WINDOWS+EOL_WINDOWS;

        LTypeCode.FImpl :=
          '{ '+LTypeName+'List }'+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          'Function '+LTypeName+'List.Link : '+LTypeName+'List;'+EOL_WINDOWS+
          'Begin'+EOL_WINDOWS+
          '  Result := '+LTypeName+'List(Inherited Link);'+EOL_WINDOWS+
          'End;'+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          'Function '+LTypeName+'List.Clone : '+LTypeName+'List;'+EOL_WINDOWS+
          'Begin'+EOL_WINDOWS+
          '  Result := '+LTypeName+'List(Inherited Clone);'+EOL_WINDOWS+
          'End;'+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          'Function '+LTypeName+'List.New : '+LTypeName+';'+EOL_WINDOWS+
          'Begin'+EOL_WINDOWS+
          '  Result := '+LTypeName+'(Inherited New);'+EOL_WINDOWS+
          'End;'+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          'Function '+LTypeName+'List.ItemClass : TAdvObjectClass;'+EOL_WINDOWS+
          'Begin'+EOL_WINDOWS+
          '  Result := '+LTypeName+';'+EOL_WINDOWS+
          'End;'+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          'Function '+LTypeName+'List.GetElementByIndex(Const iIndex : Integer) : '+LTypeName+';'+EOL_WINDOWS+
          'Begin'+EOL_WINDOWS+
          '  Result := '+LTypeName+'(ObjectByIndex[iIndex]);'+EOL_WINDOWS+
          'End;'+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          'Procedure '+LTypeName+'List.SetElementByIndex(Const iIndex : Integer; Const oValue : '+LTypeName+');'+EOL_WINDOWS+
          'Begin'+EOL_WINDOWS+
          '  Inherited ObjectByIndex[iIndex] := oValue;'+EOL_WINDOWS+
          'End;'+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          'Function '+LTypeName+'List.Get(Const aValue : Integer) : '+LTypeName+';'+EOL_WINDOWS+
          'Begin'+EOL_WINDOWS+
          '  Result := '+LTypeName+'(Inherited Get(aValue));'+EOL_WINDOWS+
          'End;'+EOL_WINDOWS+EOL_WINDOWS+
          ''+EOL_WINDOWS;
      End;
    End;
End;

Function TIdSoapWSDLToAdvConvertor.WriteComplexType(AMethod : TIdSoapITIMethod; ATypeName : TQName; AClassName : String; AType: TIdSoapWsdlComplexType; AOp : TIdSoapWSDLBindingOperationMessage; Out VAncestor, VImpl, VReg : String): String;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.WriteComplexType';
Var
  LPrivate1 : String;
  LPrivate2 : String;
  LAssign : String;
  LDefine : String;
  LPublic : String;
  LDestroy : String;
  LCreate : String;
  i, j : Integer;
  LProp : TIdSoapWsdlSimpleType;
  LXMLName : String;
  LName : String;
  LArrayType : String;
  LRef : TIdSoapWsdlElementDefn;
  LInfo : TQName;
  LMaxOccurs : String;
  LType : String;
  LDescendents : TObjectList;
  LDef : String;
  aFieldType : TFieldType;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AType.TestValid(TIdSoapWsdlComplexType), ASSERT_LOCATION+': self is not valid');

  LPrivate1 := '';
  LPrivate2 := '';
  LAssign := '';
  LDefine := '';
  LPublic := '';
  LCreate := '';
  LDestroy := '';
  LInfo := Nil;
  VImpl := '{ '+AClassName+' }'+EOL_WINDOWS+EOL_WINDOWS+
    'Function '+AClassName+'.Link : '+AClassName+';'+EOL_WINDOWS+
    'Begin'+EOL_WINDOWS+
    '  Result := '+AClassName+'(Inherited Link);'+EOL_WINDOWS+
    'End;'+EOL_WINDOWS+
    ''+EOL_WINDOWS+
    ''+EOL_WINDOWS+
    'Function '+AClassName+'.Clone : '+AClassName+';'+EOL_WINDOWS+
    'Begin'+EOL_WINDOWS+
    '  Result := '+AClassName+'(Inherited Clone);'+EOL_WINDOWS+
    'End;'+EOL_WINDOWS+
    ''+EOL_WINDOWS+
    ''+EOL_WINDOWS;

  LDescendents := TObjectList.Create(True);
  Try
    ListDescendents(LDescendents, ATypeName);
    VReg := '  Factory.RegisterClass('+AClassName+');'+EOL_WINDOWS;
  Finally
    FreeAndNil(LDescendents);
  End;
  For i := 0 To AType.Elements.count -1 Do
    Begin
    LDef := '';
    If AType.Elements.Objects[i] Is TIdSoapWsdlSimpleType Then
      Begin
      LProp := AType.Elements.Objects[i] As TIdSoapWsdlSimpleType;
      If LProp.Name = '' Then
        Begin
        VImpl := '';
        VReg := '';
        LXMLName := '';
        Result := 'TIdSoapRawXML';
        FComments.Add('* Property of type ##any in Class '+AClassName+' coded as TIdSoapRawXML. Consult doco for further information');
        FComments.Add('');
        Exit;
        End
      Else
        Begin
        LName := ChoosePascalName(AClassName, LProp.Name, True);
        LXMLName := LProp.Name;
        LInfo := LProp.Info;
        LMaxOccurs := LProp.MaxOccurs;
        LDef := LProp.DefaultValue;
        End;
      End
    Else
      Begin
      LRef := AType.Elements.Objects[i] As TIdSoapWsdlElementDefn;
      LMaxOccurs := LRef.MaxOccurs;
      j := FWsdl.SchemaSection[LRef.TypeInfo.NameSpace].Elements.IndexOf(LRef.TypeInfo.Name);
      Assert(j <> -1, ASSERT_LOCATION+': Element {'+LRef.TypeInfo.NameSpace+'}'+LRef.TypeInfo.Name+' not declared in the WSDL ['+FWsdl.SchemaSection[LRef.TypeInfo.NameSpace].Types.CommaText+']');
      LRef := FWsdl.SchemaSection[LRef.TypeInfo.NameSpace].Elements.Objects[j] As TIdSoapWsdlElementDefn;
      // this type can (and usually will be) a complex
      LName := ChoosePascalName(AClassName, LRef.Name, True);
      LXMLName := LRef.Name;
      LInfo := LRef.TypeInfo;
      End;
    If LMaxOccurs = 'unbounded' Then
      Begin
      LArrayType := CreateArrayType(AMethod, AOp, LInfo);
      LPrivate1 := LPrivate1 + '      F'+LName+' : '+LArrayType+';'+EOL_WINDOWS;
      LPrivate2 := LPrivate2 + '      Function Get'+LName+' : '+LArrayType+';'+EOL_WINDOWS;
      LPrivate2 := LPrivate2 + '      Procedure Set'+LName+'(Const oValue : '+LArrayType+');'+EOL_WINDOWS;
      LAssign := LAssign + '  '+LName+' := '+AClassName+'(oObject).F'+LName+'.Clone;'+EOL_WINDOWS;
      LDefine := LDefine + '  oFiler['''+LXMLName+'''].DefineObject(F'+LName+', '+LArrayType+');'+EOL_WINDOWS;
      LPublic := LPublic +   '      Property '+LName+' : '+LArrayType+' read Get'+LName+' write Set'+LName+';'+EOL_WINDOWS;
      LDestroy := LDestroy + '  F'+LName+'.Free;'+EOL_WINDOWS;
      LCreate := LCreate + '  F'+LName+' := '+LArrayType+'.Create;'+EOL_WINDOWS;
      VImpl := VImpl +
        'Function '+AClassName+'.Get'+LName+' : '+LArrayType+';'+EOL_WINDOWS+
        'Begin'+EOL_WINDOWS+
        '  Assert(Invariants(''Get'+LName+''', F'+LName+', '+LArrayType+', ''F'+LName+'''));'+EOL_WINDOWS+
        ''+EOL_WINDOWS+
        '  Result := F'+LName+';'+EOL_WINDOWS+
        'End;'+EOL_WINDOWS+EOL_WINDOWS+EOL_WINDOWS+
        'Procedure '+AClassName+'.Set'+LName+'(Const oValue : '+LArrayType+');'+EOL_WINDOWS+
        'Begin'+EOL_WINDOWS+
        '  Assert(Not Assigned(oValue) Or Invariants(''Set'+LName+''', oValue, '+LArrayType+', ''Value''));'+EOL_WINDOWS+
        ''+EOL_WINDOWS+
        '  F'+LName+'.Free;'+EOL_WINDOWS+
        '  F'+LName+' := oValue;'+EOL_WINDOWS+
        'End;'+EOL_WINDOWS+EOL_WINDOWS+EOL_WINDOWS;
      End
    Else
      Begin
      Assert((LMaxOccurs = '') Or (LMaxOccurs = '1'), ASSERT_LOCATION+': unacceptable value for MaxOccurs: "'+LMaxOccurs+'"');
      LPrivate1 := LPrivate1 + '      F'+LName+' : '+ProcessType(AMethod, LXMLName, AOp, LInfo, aFieldType)+';'+EOL_WINDOWS;
      If TypeIsArray(LInfo) Then
        Begin
        LArrayType := ProcessType(AMethod, LXMLName, AOp, LInfo, aFieldType);
        LPrivate2 := LPrivate2 + '      Function Get'+LName+' : '+LArrayType+';'+EOL_WINDOWS;
        LPrivate2 := LPrivate2 + '      Procedure Set'+LName+'(Const oValue : '+LArrayType+');'+EOL_WINDOWS;
        LPublic := LPublic + '      Property '+LName+' : '+LArrayType+' read Get'+LName+' write Set'+LName+';'+EOL_WINDOWS;
        LAssign := LAssign + '  '+LName+' := '+AClassName+'(oObject).F'+LName+'.Clone;'+EOL_WINDOWS;
        LDefine := LDefine + '  oFiler['''+LXMLName+'''].DefineObject(F'+LName+', '+LArrayType+');'+EOL_WINDOWS;
        LDestroy := LDestroy + '    F'+LName+'.Free;'+EOL_WINDOWS;
        LCreate := LCreate + '  F'+LName+' := '+LArrayType+'.Create;'+EOL_WINDOWS;
        VImpl := VImpl +
          'Function '+AClassName+'.Get'+LName+' : '+LArrayType+';'+EOL_WINDOWS+
          'Begin'+EOL_WINDOWS+
          '  Assert(Invariants(''Get'+LName+''', F'+LName+', '+LArrayType+', ''F'+LName+'''));'+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          '  Result := F'+LName+';'+EOL_WINDOWS+
          'End;'+EOL_WINDOWS+EOL_WINDOWS+EOL_WINDOWS+
          'Procedure '+AClassName+'.Set'+LName+'(Const oValue : '+LArrayType+');'+EOL_WINDOWS+
          'Begin'+EOL_WINDOWS+
          '  Assert(Not Assigned(oValue) Or Invariants(''Set'+LName+''', oValue, '+LArrayType+', ''Value''));'+EOL_WINDOWS+
          '  F'+LName+'.Free;'+EOL_WINDOWS+
          ''+EOL_WINDOWS+
          '  F'+LName+' := oValue;'+EOL_WINDOWS+
          'End;'+EOL_WINDOWS+EOL_WINDOWS+EOL_WINDOWS;
        End
      Else
        Begin
        LType := ProcessType(AMethod, LXMLName, AOp, LInfo, aFieldType);
        If (aFieldType <> ftClass) Then
        Begin
          LAssign := LAssign + '  '+LName+' := '+AClassName+'(oObject).'+LName+';'+EOL_WINDOWS;
          LPublic := LPublic + '      Property '+LName+' : '+LType+' read F'+LName+' write F'+LName + ';' + EOL_WINDOWS;
          If (aFieldType = ftEnum) Then
            LDefine := LDefine + '  oFiler['''+LXMLName+'''].DefineEnumerated(F'+LName+', '+Copy(LType, 2, $FF)+'NameArray);'+EOL_WINDOWS
          Else If LType = 'TDateTime' Then
            LDefine := LDefine + '  oFiler['''+LXMLName+'''].DefineDateTime(F'+LName+');'+EOL_WINDOWS
          Else If aFieldType = ftClass Then
            LDefine := LDefine + '  oFiler['''+LXMLName+'''].DefineObject(F'+LName+', '+LType+');'+EOL_WINDOWS
          Else if LType = 'Int64' Then
            LDefine := LDefine + '  oFiler['''+LXMLName+'''].DefineInteger(F'+LName+');'+EOL_WINDOWS
          Else if LType = 'Double' Then
            LDefine := LDefine + '  oFiler['''+LXMLName+'''].DefineReal(F'+LName+');'+EOL_WINDOWS
          Else
            LDefine := LDefine + '  oFiler['''+LXMLName+'''].Define'+LType+'(F'+LName+');'+EOL_WINDOWS;
        End
        Else
        Begin
          LAssign := LAssign + '  '+LName+' := '+AClassName+'(oObject).F'+LName+'.Clone;'+EOL_WINDOWS;
          LPrivate2 := LPrivate2 + '      Function Get'+LName+' : '+LType+';'+EOL_WINDOWS;
          LPrivate2 := LPrivate2 + '      Procedure Set'+LName+'(Const oValue : '+LType+');'+EOL_WINDOWS;
          LPrivate2 := LPrivate2 + '      Function GetHas'+LName+' : Boolean;'+EOL_WINDOWS;
          LPrivate2 := LPrivate2 + '      Procedure SetHas'+LName+'(Const Value : Boolean);'+EOL_WINDOWS;
          LPublic := LPublic + '      Property '+LName+' : '+LType+' read Get'+LName+' write Set'+LName+';'+EOL_WINDOWS;
          LPublic := LPublic + '      Property Has'+LName+' : Boolean read GetHas'+LName+' write SetHas'+LName+';'+EOL_WINDOWS;
          LDefine := LDefine + '  oFiler['''+LXMLName+'''].DefineObject(F'+LName+', '+LType+');'+EOL_WINDOWS;
          LDestroy := LDestroy + '  F'+LName+'.Free;'+EOL_WINDOWS;
          VImpl := VImpl +
            'Function '+AClassName+'.Get'+LName+' : '+LType+';'+EOL_WINDOWS+
            'Begin'+EOL_WINDOWS+
            '  Assert(Invariants(''Get'+LName+''', F'+LName+', '+LType+', ''F'+LName+'''));'+EOL_WINDOWS+
            ''+EOL_WINDOWS+
            '  Result := F'+LName+';'+EOL_WINDOWS+
            'End;'+EOL_WINDOWS+EOL_WINDOWS+EOL_WINDOWS+
            'Procedure '+AClassName+'.Set'+LName+'(Const oValue : '+LType+');'+EOL_WINDOWS+
            'Begin'+EOL_WINDOWS+
            '  Assert(Not Assigned(oValue) Or Invariants(''Set'+LName+''', oValue, '+LType+', ''Value''));'+EOL_WINDOWS+
            ''+EOL_WINDOWS+
            '  F'+LName+'.Free;'+EOL_WINDOWS+
            '  F'+LName+' := oValue;'+EOL_WINDOWS+
            'End;'+EOL_WINDOWS+EOL_WINDOWS+EOL_WINDOWS+
            'Function '+AClassName+'.GetHas'+LName+' : Boolean;'+EOL_WINDOWS+
            'Begin'+EOL_WINDOWS+
            '  Result := Assigned(F'+LName+');'+EOL_WINDOWS+
            'End;'+EOL_WINDOWS+EOL_WINDOWS+EOL_WINDOWS+
            'Procedure '+AClassName+'.SetHas'+LName+'(Const Value : Boolean);'+EOL_WINDOWS+
            'Begin'+EOL_WINDOWS+
            '  If Assigned(F'+LName+') And Not Value Then'+EOL_WINDOWS+
            '  Begin'+EOL_WINDOWS+
            '    F'+LName+'.Free;'+EOL_WINDOWS+
            '    F'+LName+' := Nil;'+EOL_WINDOWS+
            '  End'+EOL_WINDOWS+
            '  Else If Not Assigned(F'+LName+') And Value Then'+EOL_WINDOWS+
            '  Begin'+EOL_WINDOWS+
            '    F'+LName+' := '+LType+'.Create;'+EOL_WINDOWS+
            '  End;'+EOL_WINDOWS+
            'End;'+EOL_WINDOWS+EOL_WINDOWS+EOL_WINDOWS;
        End;
        If LDef <> '' Then
          Begin
          LCreate := LCreate + 'to complete: default value for '+LName;
(*          If AnsiSameText(LType, 'String') Or AnsiSameText(LType, 'Char') Then
            Begin
            LCreate := LCreate + '  F'+LName+' := '''+LDef+''';'+EOL_WINDOWS;
            End
          Else
            Begin
            LCreate := LCreate + '  F'+LName+' := '+LDef+';'+EOL_WINDOWS;
            If Not AnsiSameText(LType, 'Double') Then
              Begin
              LPublic := LPublic + ' default '+LDef;
              End;
            End;  *)
          End;
//        LPublic := LPublic+';';
        End;
      End;
    End;
  If AType.ExtensionBase.Name <> '' Then
    Begin
    VAncestor := ProcessType(AMethod, '', AOp, AType.ExtensionBase, aFieldType);
    Result := '  '+AClassName+' = Class ('+VAncestor+')';
    End
  Else
    Begin
    Result :=
      '  '+AClassName+' = Class (TAdvPersistent)';
    End;
  Result := Result +EOL_WINDOWS;

  If (LPrivate1 <> '') Or (LPrivate2 <> '') Then
    Begin
    Result := Result +
      '    Private'+EOL_WINDOWS+
      LPrivate1+LPrivate2;
    End;
  Result := Result +  '    Public'+EOL_WINDOWS;
  If LCreate <> '' Then
      Result := Result + '      Constructor Create; Override;'+EOL_WINDOWS;
  If LDestroy <> '' Then
      Result := Result + '      destructor Destroy; Override;'+EOL_WINDOWS;
  Result := Result + '      Function Link : '+AClassName+'; '+EOL_WINDOWS;
  Result := Result + '      Function Clone : '+AClassName+'; '+EOL_WINDOWS;
  If LAssign <> '' Then
    Result := Result + '      Procedure Assign(oObject : TAdvObject); Override;'+EOL_WINDOWS;
  If LDefine <> '' Then
    Result := Result + '      Procedure Define(oFiler : TAdvFiler); Override;'+EOL_WINDOWS;
  If LPublic <> '' Then
  Begin
    Result := Result + EOL_WINDOWS;
    Result := Result + LPublic;
  End;

  Result := Result + '  End;'+EOL_WINDOWS+EOL_WINDOWS;

  If LCreate <> '' Then
    Begin
    VImpl := VImpl +
      'constructor '+AClassName+'.create;'+EOL_WINDOWS+
      'Begin'+EOL_WINDOWS+
      '  Inherited;'+EOL_WINDOWS+
      LCreate+
      'End;'+EOL_WINDOWS+EOL_WINDOWS;
    End;
  If LDestroy <> '' Then
    Begin
    VImpl := VImpl +
      'Destructor '+AClassName+'.destroy;'+EOL_WINDOWS+
      'Begin'+EOL_WINDOWS+
      LDestroy+
      '  Inherited;'+EOL_WINDOWS+
      'End;'+EOL_WINDOWS+EOL_WINDOWS+EOL_WINDOWS;
    End;
  If (LAssign <> '') Then
    VImpl := VImpl +
    'Procedure '+AClassName+'.Assign(oObject : TAdvObject);'+EOL_WINDOWS+
    'Begin'+EOL_WINDOWS+
    '  Inherited;'+EOL_WINDOWS+EOL_WINDOWS+
    LAssign+
    'End;'+EOL_WINDOWS+
    ''+EOL_WINDOWS+EOL_WINDOWS;
  If (LDefine <> '') Then
    VImpl := VImpl +
    'Procedure '+AClassName+'.Define(oFiler : TAdvFiler);'+EOL_WINDOWS+
    'Begin'+EOL_WINDOWS+
    '  Inherited;'+EOL_WINDOWS+EOL_WINDOWS+
    LDefine+
    'End;'+EOL_WINDOWS+EOL_WINDOWS+
    ''+EOL_WINDOWS;
End;




Procedure TIdSoapWSDLToAdvConvertor.ProcessPorts;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.ProcessPorts';
Var
  i, j : Integer;
  LEntry  : TPortTypeEntry;
  LNamespace : String;
  s : String;
  LInterface : TIdSoapITIInterface;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(FIti.TestValid(TIdSoapITI), ASSERT_LOCATION+': self is not valid');
  Assert(FWsdl.TestValid(TIdSoapWsdl), ASSERT_LOCATION+': self is not valid');

  LNamespace := '';
  For i := 0 To FValidPortTypes.count - 1 Do
    Begin
    LEntry := FValidPortTypes.objects[i] As TPortTypeEntry;
    LInterface := GetInterfaceForEntry(LEntry);
    For j := 0 To LEntry.FPort.Operations.count -1 Do
      Begin
      If LNamespace = '' Then
        Begin
        LNamespace := GetOpNamespace(LEntry.FPort.Operations.Objects[j] As TIdSoapWSDLPortTypeOperation, LEntry.FBind);
        If LNamespace = '' Then
          Begin
          LNamespace := FWsdl.Namespace;
          End
        End
      Else
        Begin
        s := GetOpNamespace(LEntry.FPort.Operations.Objects[j] As TIdSoapWSDLPortTypeOperation, LEntry.FBind);
        Assert((s = '') Or (s = LNamespace), ASSERT_LOCATION+': IndySoap cannot deal with interfaces that cover more than a single namespace. Please refer your WSDL to indy-soap-public@yahoogroups.com for consideration');
        // if this is a problem, we could back the scope of this check back to a single interface
        End;
      End;
    LInterface.Namespace := LNamespace;
    End;

  For i := 0 To FValidPortTypes.count - 1 Do
    Begin
    LEntry := FValidPortTypes.objects[i] As TPortTypeEntry;
    LInterface := GetInterfaceForEntry(LEntry);
    For j := 0 To LEntry.FPort.Operations.count -1 Do
      Begin
      ProcessOperation(LInterface, LEntry.FPort.Operations.Objects[j] As TIdSoapWSDLPortTypeOperation, LEntry.FBind);
      End;
    End;
End;

Procedure TIdSoapWSDLToAdvConvertor.WriteHeader;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.WriteHeader';
Var
  i : Integer;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(FIti.TestValid(TIdSoapITI), ASSERT_LOCATION+': self is not valid');

  writeln('Unit '+FUnitName+';');
  writeln('');
  writeln('{---------------------------------------------------------------------------');
  writeln('This file generated by the IndySoap WSDL -> Pascal translator (Kestral Extensions for AdvLibrary)');
  writeln('');
  writeln('Source:   '+FWSDLSource);
  writeln('Control File:     '+FProjectName);
  writeln('Date:     '+FormatDateTime('c', now));
  writeln('IndySoap: V'+ID_SOAP_VERSION);
  If FComments.count > 0 Then
    Begin

    writeln('Notes:');
    For i := 0 To FComments.count -1 Do
      Begin
      writeln('   '+FComments[i]);
      End;
    End;
  writeln('');
  writeln('To regenerate this file, open the Control File above in IdSoapTools and execute (F9)');
  writeln('');
  writeln('---------------------------------------------------------------------------}');
  writeln('');
  writeln('Interface');
  writeln('');
End;

Function TypeCompare(AList: TStringList; AIndex1, AIndex2: Integer): Integer;
Var
  LFrag1 : TIdSoapWSDLPascalFragment;
  LFrag2 : TIdSoapWSDLPascalFragment;
Begin
  LFrag1 := AList.Objects[AIndex1] As TIdSoapWSDLPascalFragment;
  LFrag2 := AList.Objects[AIndex2] As TIdSoapWSDLPascalFragment;
  Result := CompareText(LFrag2.FAncestor, LFrag1.FAncestor);
  If Result = 0 Then
    Begin
    Result := CompareText(LFrag2.FPascalName, LFrag1.FPascalName);
    End;
End;

Procedure TIdSoapWSDLToAdvConvertor.WriteTypes;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.WriteTypes';
Var
  i : Integer;
  LFlag : Boolean;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(FIti.TestValid(TIdSoapITI), ASSERT_LOCATION+': self is not valid');

  {$IFDEF VCL5ORABOVE}
  // no sorting if D4 - user will have to sort this out themselves
  FDefinedTypes.CustomSort(TypeCompare);
  {$ENDIF}

  LFlag := False;
  For i := FDefinedTypes.count - 1 DownTo 0 Do
    Begin
    If Not (FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FHidden And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FIncludeInPascal) And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FTypeType = idttSimple) Then
      Begin
      If (Not LFlag) Then
      Begin
        writeln('Type');
        LFlag := True;
      End;
      Write((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FCode);
      End;
    End;
  If LFlag Then
    Begin
    WriteLn('');
//    LFlag := False;
    End;

  LFlag := False;
  For i := FDefinedTypes.count - 1 DownTo 0 Do
    Begin
    If Not (FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FHidden And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FIncludeInPascal) And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FTypeType = idttSimple) Then
      Begin
      If (Not LFlag) Then
      Begin
        writeln('Const');
        LFlag := True;
      End;
      Write((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FDecl);
      End;
    End;
  If LFlag Then
    Begin
    WriteLn('');
    LFlag := False;
    End;


  writeln('Type');

  For i := FDefinedTypes.count - 1 DownTo 0 Do
    Begin
    If Not (FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FHidden And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FIncludeInPascal) And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FTypeType = idttSet) Then
      Begin
      LFlag := True;
      Write((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FCode);
      End;
    End;
  If LFlag Then
    Begin
    WriteLn('');
    LFlag := False;
    End;
  For i := FDefinedTypes.count - 1 DownTo 0 Do
    Begin
    If Not (FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FHidden And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FIncludeInPascal) And (((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FTypeType = idttClass) Or ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FTypeType = idttList)) Then
      Begin
      LFlag := True;
      WriteLn('  '+(FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FPascalName+' = Class;');
      End;
    End;
  If LFlag Then
    Begin
    WriteLn('');
  //  LFlag := False;
    End;

  For i := FDefinedTypes.count - 1 DownTo 0 Do
    Begin
    If Not (FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FHidden And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FIncludeInPascal) And (((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FTypeType = idttClass) Or ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FTypeType = idttList)) Then
      Begin
//      LFlag := True;
      Writeln((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FCode);
      End;
    End;

(*  If FNameAndTypeComments.count > 0 Then
    Begin
    WriteLn('{!');
    FNameAndTypeComments.sort;
    For i := 0 To FNameAndTypeComments.count -1 Do
      Begin
      Writeln('  '+FNameAndTypeComments[i]+';');
      End;
    WriteLn('}');
    WriteLn('');
    End; *)
End;

Procedure TIdSoapWSDLToAdvConvertor.WriteImpl;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.WriteTypes';
Var
  i : Integer;
  LFlag : Boolean;
  oFrag : TIdSoapWSDLPascalFragment;
  c : Integer;
  t : Integer;
  sName : String;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(FIti.TestValid(TIdSoapITI), ASSERT_LOCATION+': self is not valid');

  LFLag := false;
  writeln('Type');

  For i := FDefinedTypes.count - 1 DownTo 0 Do
    Begin
    If (FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FHidden And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FIncludeInPascal) And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FTypeType = idttSet) Then
      Begin
      LFlag := True;
      Write((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FCode);
      End;
    End;
  If LFlag Then
    Begin
    WriteLn('');
    LFlag := False;
    End;
  For i := FDefinedTypes.count - 1 DownTo 0 Do
    Begin
    If (FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FHidden And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FIncludeInPascal) And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FTypeType = idttClass) Then
      Begin
      LFlag := True;
      Write((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FDecl);
      End;
    End;
  If LFlag Then
    Begin
    WriteLn('');
    LFlag := False;
    End;
  For i := FDefinedTypes.count - 1 DownTo 0 Do
    Begin
    If (FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FHidden And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FIncludeInPascal) And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FTypeType = idttList) Then
      Begin
      LFlag := True;
      Write((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FCode);
      End;
    End;
  If LFlag Then
    Begin
    WriteLn('');
    LFlag := False;
    End;
  For i := FDefinedTypes.count - 1 DownTo 0 Do
    Begin
    If (FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FHidden And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FIncludeInPascal) And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FTypeType = idttClass) Then
      Begin
      LFlag := True;
      Writeln((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FCode);
      End;
    End;
  If LFlag Then
    Begin
    WriteLn('');
    End;

//  LFlag := False;
  For i := FDefinedTypes.count - 1 DownTo 0 Do
    Begin
    oFrag := (FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment);
    If (oFrag.FIncludeInPascal) And ((oFrag.FTypeType = idttClass) Or (oFrag.FTypeType = idttList)) Then
      Begin
      If oFrag.FImpl <> '' Then
        Begin
        Write(oFrag.FImpl);
        End;
      End;
    End;
  Writeln('');
  WriteClientImpl();
  Writeln('');
  Writeln('Initialization');
  Write('  Factory.RegisterClassArray([');
  c := Length('  Factory.RegisterClassArray([');
  t := 0;
  LFlag := False;
  For i := FDefinedTypes.Count - 1 DownTo 0 Do
  Begin
    If ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FIncludeInPascal) And ((FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FTypeType = idttClass) Then
    Begin
      sName := (FDefinedTypes.Objects[i] As TIdSoapWSDLPascalFragment).FPascalName;
      If LFlag Then
        Write(', ')
      Else
        LFlag := True;
      If (c > 100) And (T > 1) Then
      Begin
        writeln('');
        Write('         ');
        c := 10;
        t := 0;
      End;
      Inc(c, Length(sName)+2);
      Write(sName);
      Inc(t);
    End;
  End;
  Writeln(']);');
End;

Function TIdSoapWSDLToAdvConvertor.ChoosePascalNameForType(Const ASoapName: String): String;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.ChoosePascalNameForType';
Var
  LModified : Boolean;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(ASoapname <> '', ASSERT_LOCATION+': SoapName is blank');

  Result := 'T'+UnitName_+ASoapName;

  LModified := False;
  While (FUsedPascalIDs.IndexOf(Result) > -1) Or (FReservedPascalNames.Indexof(Result) > -1) Do
    Begin
    If LModified Then
      Begin
      If Result[Length(Result)] = '_' Then
        Begin
        Result := Result + '1';
        End
      Else
        Begin
        If Result[Length(Result)] = '9' Then
          Begin
          Result[Length(Result)] := 'A';
          End
        Else
          Begin
          Assert(Result[Length(Result)] < 'Z', ASSERT_LOCATION+': Ran out of space generating an alternate representation for the name "'+ASoapName+'"');
          Result[Length(Result)] := Chr(ord(Result[Length(Result)])+1);
          End;
        End;
      End
    Else
      Begin
      Result := Result + '_';
      LModified := True;
      End;
    End;
  FUsedPascalIDs.Add(Result);
End;

Procedure TIdSoapWSDLToAdvConvertor.LoadReservedWordList;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.LoadReservedWordList';
Begin
  FReservedPascalNames.sorted := True;
  FReservedPascalNames.Duplicates := dupError;

  // this list taken from D6 help, subject "reserved words"
  FReservedPascalNames.Add('and');
  FReservedPascalNames.Add('array');
  FReservedPascalNames.Add('as');
  FReservedPascalNames.Add('asm');
  FReservedPascalNames.Add('Begin');
  FReservedPascalNames.Add('case');
  FReservedPascalNames.Add('Class');
  FReservedPascalNames.Add('classtype');
  FReservedPascalNames.Add('const');
  FReservedPascalNames.Add('constructor');
  FReservedPascalNames.Add('Destructor');
  FReservedPascalNames.Add('dispinterface');
  FReservedPascalNames.Add('div');
  FReservedPascalNames.Add('do');
  FReservedPascalNames.Add('downto');
  FReservedPascalNames.Add('else');
  FReservedPascalNames.Add('End');
  FReservedPascalNames.Add('except');
  FReservedPascalNames.Add('exports');
  FReservedPascalNames.Add('file');
  FReservedPascalNames.Add('finalization');
  FReservedPascalNames.Add('finally');
  FReservedPascalNames.Add('for');
  FReservedPascalNames.Add('Function');
  FReservedPascalNames.Add('goto');
  FReservedPascalNames.Add('if');
  FReservedPascalNames.Add('implementation');
  FReservedPascalNames.Add('in');
  FReservedPascalNames.Add('Inherited');
  FReservedPascalNames.Add('initialization');
  FReservedPascalNames.Add('inline');
  FReservedPascalNames.Add('interface');
  FReservedPascalNames.Add('is');
  FReservedPascalNames.Add('label');
  FReservedPascalNames.Add('library');
  FReservedPascalNames.Add('mod');
  FReservedPascalNames.Add('nil');
  FReservedPascalNames.Add('not');
  FReservedPascalNames.Add('object');
  FReservedPascalNames.Add('of');
  FReservedPascalNames.Add('or');
  FReservedPascalNames.Add('out');
  FReservedPascalNames.Add('packed');
  FReservedPascalNames.Add('Procedure');
  FReservedPascalNames.Add('program');
  FReservedPascalNames.Add('Property');
  FReservedPascalNames.Add('raise');
  FReservedPascalNames.Add('record');
  FReservedPascalNames.Add('repeat');
  FReservedPascalNames.Add('resourcestring');
  FReservedPascalNames.Add('set');
  FReservedPascalNames.Add('shl');
  FReservedPascalNames.Add('shr');
  FReservedPascalNames.Add('string');
  FReservedPascalNames.Add('system');
  FReservedPascalNames.Add('then');
  FReservedPascalNames.Add('threadvar');
  FReservedPascalNames.Add('to');
  FReservedPascalNames.Add('try');
  FReservedPascalNames.Add('type');
  FReservedPascalNames.Add('unit');
  FReservedPascalNames.Add('until');
  FReservedPascalNames.Add('uses');
  FReservedPascalNames.Add('var');
  FReservedPascalNames.Add('while');
  FReservedPascalNames.Add('with');
  FReservedPascalNames.Add('xor');
  FReservedPascalNames.Add('private');
  FReservedPascalNames.Add('protected');
  FReservedPascalNames.Add('public');
  FReservedPascalNames.Add('published');
  FReservedPascalNames.Add('automated');
  FReservedPascalNames.Add('at');
  FReservedPascalNames.Add('on');

  // also added on principle - could be *real* confusing
  FReservedPascalNames.Add('ShortInt');
  FReservedPascalNames.Add('Byte');
  FReservedPascalNames.Add('SmallInt');
  FReservedPascalNames.Add('Word');
  FReservedPascalNames.Add('Integer');
  FReservedPascalNames.Add('Cardinal');
  FReservedPascalNames.Add('Char');
  FReservedPascalNames.Add('Boolean');
  FReservedPascalNames.Add('Single');
  FReservedPascalNames.Add('Double');
  FReservedPascalNames.Add('Extended');
  FReservedPascalNames.Add('Comp');
  FReservedPascalNames.Add('Currency');
  FReservedPascalNames.Add('ShortString');
  FReservedPascalNames.Add('WideChar');
  FReservedPascalNames.Add('WideString');
  FReservedPascalNames.Add('Int64');

  FReservedPascalNames.Add('Condition');
  FReservedPascalNames.Add('Link');
  FReservedPascalNames.Add('Error');
  FReservedPascalNames.Add('Clone');
  FReservedPascalNames.Add('Define');
  FReservedPascalNames.Add('Assign');
End;

Function IsValidIdentChar(ACh : Char; AIndex : Integer):Boolean;
Begin
  If AIndex = 1 Then
    Begin
    Result := CharInSet(upcase(ACh), ['_', 'A'..'Z']);
    End
  Else
    Begin
    Result := CharInSet(upcase(ACh), ['_', 'A'..'Z', '0'..'9']);
    End;
End;


function TIdSoapWSDLToAdvConvertor.AsSymbolName(AValue: String): TSymbolName;
begin
  if length(AValue) > 255 then
    raise Exception.Create('Name too long: "'+AValue+'"');
  if not IsValidIdent(AValue{$IFDEF UNICODE}, false{$ENDIF}) then
    raise Exception.Create('Name contains invalid characters: "'+AValue+'"');
  result := TSymbolName(AValue);
end;

Function TIdSoapWSDLToAdvConvertor.ChoosePascalName(Const AClassName, ASoapName: String; AAddNameChange : Boolean): String;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.ChoosePascalName';
Var
  LModified : Boolean;
  LDefinition : String;
  i : Integer;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(isXMLName(ASoapname), ASSERT_LOCATION+': SoapName is blank');

  Result := ASoapName;
  For i := Length(Result) DownTo 1 Do
    Begin
    If Not IsValidIdentChar(Result[i], i) Then
      Begin
      Delete(Result, i, 1);
      End;
    End;
  While (Result <> '') And (Not IsValidIdentChar(Result[1], 1)) Do
    Begin
    Delete(Result, 1, 1);
    End;
  If Result = '' Then
    Begin
    Result := 'Unnamed';
    End;
  LModified := False;
  While (FReservedPascalNames.Indexof(Result) > -1) Do
    Begin
    If LModified Then
      Begin
      If Result[Length(Result)] = '_' Then
        Begin
        Result := Result + '1';
        End
      Else
        Begin
        If Result[Length(Result)] = '9' Then
          Begin
          Result[Length(Result)] := 'A';
          End
        Else
          Begin
          Assert(Result[Length(Result)] < 'Z', ASSERT_LOCATION+': Ran out of space generating an alternate representation for the name "'+ASoapName+'"');
          Result[Length(Result)] := Chr(ord(Result[Length(Result)])+1);
          End;
        End;
      End
    Else
      Begin
      Result := Result + '_';
      LModified := True;
      End;
    End;
  If AAddNameChange And (Result <> ASoapname) Then
    Begin
    If AClassName <> '' Then
      Begin
      LDefinition := 'Name: '+AClassName+'.'+Result+' = '+ASoapName;
      End
    Else
      Begin
      LDefinition := 'Name: '+Result+' = '+ASoapName;
      End;
//    If FNameAndTypeComments.indexof(LDefinition) = -1 Then
//      Begin
//      FNameAndTypeComments.Add(LDefinition);
//      End;
    End;
End;

{
Function TIdSoapWSDLToAdvConvertor.AllMethodsAreDocument(AIntf: TIdSoapITIInterface): Boolean;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.ChoosePascalName';
Var
  i : Integer;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AIntf.TestValid(TIdSoapITIInterface), ASSERT_LOCATION+': self is not valid');
  Result := AIntf.Methods.count > 0;
  For i := 0 To AIntf.Methods.count - 1 Do
    Begin
    Result := Result And ((AIntf.Methods.objects[i] As TIdSoapITIMethod).EncodingMode = semDocument);
    End;
End;
}

Procedure TIdSoapWSDLToAdvConvertor.SetExemptTypes(AList: String);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.SetExemptTypes';
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  FExemptTypes.CommaText := AList;
  FExemptTypes.Sort;
End;

Procedure TIdSoapWSDLToAdvConvertor.SetUsesClause(AList : String);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.SetUsesClause';
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  FInterfaceUsesClause.CommaText := AList;
End;

Procedure TIdSoapWSDLToAdvConvertor.ListDescendents(ADescendents: TObjectList; AName: TQName);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.ListDescendents';
Var
  i, j: Integer;
  LNs : TIdSoapWSDLSchemaSection;
  LType : TIdSoapWSDLAbstractType;
  LMatch : TQName;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(Assigned(ADescendents), ASSERT_LOCATION+': Descendents is not valid');
  Assert(AName.TestValid(TQName), ASSERT_LOCATION+': Name is not valid');

  For i := 0 To FWsdl.SchemaSections.count - 1 Do
    Begin
    LNs := FWsdl.SchemaSections.Objects[i] As TIdSoapWSDLSchemaSection;
    For j := 0 To LNs.Types.count - 1 Do
      Begin
      LType := LNs.Types.objects[j] As TIdSoapWSDLAbstractType;
      If (LType Is TIdSoapWsdlComplexType) And AName.Equals((LType As TIdSoapWsdlComplexType).ExtensionBase) Then
        Begin
        LMatch := TQName.Create;
        LMatch.NameSpace := FWsdl.SchemaSections[i];
        LMatch.Name := LNs.Types[j];
        ADescendents.Add(LMatch);
        End;
      End;
    End;
End;

Function TIdSoapWSDLToAdvConvertor.MakeInterfaceForEntry(AEntry: TPortTypeEntry): TIdSoapITIInterface;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.MakeInterfaceForEntry';
Var
  LName : String;
  LGUID : TGUID;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AEntry.TestValid(TPortTypeEntry), ASSERT_LOCATION+': self is not valid');

  Result := TIdSoapITIInterface.Create(FIti);
  LName := AEntry.FSvc.Name;
  If AnsiSameText(Copy(LName, Length(LName)-6, 7), 'service') Then
    Begin
    Delete(LName, Length(LName)-6, 7);
    End;
  LName := 'T'+LName+'WebServiceClient';
  Result.Name := ChoosePascalName('', LName, False);
  FIti.Interfaces.AddObject(Result.Name, Result);
  CoCreateGuid(LGUID);
  Result.GUID := LGUID;
  Result.Documentation := AEntry.FSvc.Documentation;
  Result.soapAddress := GetServiceSoapAddress(AEntry.FSvc);
End;

Function TIdSoapWSDLToAdvConvertor.GetInterfaceForEntry(AEntry: TPortTypeEntry): TIdSoapITIInterface;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.GetInterfaceForEntry';
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AEntry.TestValid(TPortTypeEntry), ASSERT_LOCATION+': self is not valid');

  If OnlyOneInterface Then
    Begin
    If Assigned(FOneInterface) Then
      Begin
      Result := FOneInterface;
      If GetServiceSoapAddress(AEntry.FSvc) <> Result.SoapAddress Then
        Begin
        Result.SoapAddress := MULTIPLE_ADDRESSES;
        End;
      End
    Else
      Begin
      Result := MakeInterfaceForEntry(AEntry);
      If OneInterfaceName <> '' Then
        Begin
        Result.Name := OneInterfaceName
        End;
      FOneInterface := Result;
      End;
    End
  Else
    Begin
    If Assigned(AEntry.FSvc.Slot) Then
      Begin
      Result := AEntry.FSvc.Slot As TIdSoapITIInterface;
      End
    Else
      Begin
      Result := MakeInterfaceForEntry(AEntry);
      AEntry.FSvc.Slot := Result;
      End;
    End;
End;

Function TIdSoapWSDLToAdvConvertor.GetServiceSoapAddress(AService : TIdSoapWSDLService) : String;
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.GetServiceSoapAddress';
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(AService.TestValid(TIdSoapWSDLService), ASSERT_LOCATION+': self is not valid');

  If AService.Ports.count <> 1 Then
    Begin
    Result := MULTIPLE_ADDRESSES;
    End
  Else
    Begin
    Result := (AService.Ports.objects[0] As TIdSoapWSDLServicePort).SoapAddress;
    End;
End;

Procedure TIdSoapWSDLToAdvConvertor.AddUnit(AUnitName: String; AInInterface: Boolean);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.AddUnit';
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  Assert(IsValidIdent(AUnitName), ASSERT_LOCATION+': UnitName is not valid');

  If AInInterface Then
    Begin
    If FImplementationUsesClause.indexof(AUnitName) > -1 Then
      Begin
      FImplementationUsesClause.Delete(FImplementationUsesClause.indexof(AUnitName));
      End;
    If FInterfaceUsesClause.indexof(AUnitName) = -1 Then
      Begin
      FInterfaceUsesClause.Add(AUnitName);
      End
    End
  Else
    Begin
    If (FImplementationUsesClause.indexof(AUnitName) = -1) And (FInterfaceUsesClause.indexof(AUnitName) = -1) Then
      Begin
      FImplementationUsesClause.Add(AUnitName);
      End
    End;
End;

Procedure TIdSoapWSDLToAdvConvertor.WriteUsesClause(AList: TStringList);
Const ASSERT_LOCATION = ASSERT_UNIT+'.TIdSoapWSDLToAdvConvertor.WriteUsesClause';
Var
  i : Integer;
Begin
  Assert(Self.TestValid(TIdSoapWSDLToAdvConvertor), ASSERT_LOCATION+': self is not valid');
  If AList.Count > 0 Then
  Begin
    writeln('Uses');
    If AList.Count > 1 Then
      For i := 0 To AList.count - 2 Do
        Begin
        Writeln('  '+AList[i]+',');
        End;
    Writeln('  '+AList[AList.count -1]+';');
    writeln('');
  End;
End;


Procedure TIdSoapWSDLToAdvConvertor.CreateParamClasses;
Var
  i, j : Integer;
  LIntf : TIdSoapITIInterface;
Begin
  For i := 0 To FITI.Interfaces.count - 1 Do
    Begin
    LIntf := FITI.Interfaces.IFace[i];
    For j := 0 To LIntf.Methods.count - 1 Do
      Begin
      // ? pfArray
      CreateParamClass(LIntf, LIntf.Methods.objects[j] As TIdSoapITIMethod, 'In', [pfVar, pfConst, pfReference, pfAddress]);
      CreateParamClass(LIntf, LIntf.Methods.objects[j] As TIdSoapITIMethod, 'Out', [pfVar, pfOut]);
      End;
    End;
End;

Procedure TIdSoapWSDLToAdvConvertor.CreateParamClass(oIntf : TIdSoapITIInterface; oMethod : TIdSoapITIMethod; sSuffix : String; aFlags : TParamFlags);
Var
  oFrag : TIdSoapWSDLPascalFragment;
  i : Integer;
  oParam : TIdSoapITIParameter;
  t : Integer;
Begin
  oFrag := TIdSoapWSDLPascalFragment.Create;
  oFrag.FPascalName := oIntf.Name+'_'+oMethod.Name+'_Params_'+sSuffix;
  FDefinedTypes.AddObject(oIntf.Namespace+#1+oFrag.FPascalName, oFrag);
  oFrag.FHidden := True;
  oFrag.FIncludeInPascal := True;
  oFrag.FFieldType := ftClass;
  oFrag.FTypeType := idttClass;
  oFrag.FCode := '  '+oFrag.FPascalName+' = Class (TAdvPersistent)'+EOL_WINDOWS+
                 '    Private'+EOL_WINDOWS;
  oFrag.FImpl := '{ '+oFrag.FPascalName+' }'+EOL_WINDOWS+EOL_WINDOWS;
  t := 0;
  For i := 0 To oMethod.Parameters.Count - 1 Do
  Begin
    oParam := oMethod.Parameters.Param[i];
    If (oParam.ParamFlag In aFlags) Then
    Begin
      DefineParameter(oMethod, oFrag, oParam.Name, oParam.XmlName, AdvType(oParam.NameOfType), oParam.FieldType);
      Inc(t);
    End;
  End;
  If (sSuffix = 'Out') And (oMethod.ResultType <> '') Then
  Begin
    DefineParameter(oMethod, oFrag, 'Result', oMethod.ResultName, AdvType(oMethod.ResultType), oMethod.ResultFieldType);
    Inc(t);
  End;
  If (t > 0) Then
    oFrag.FCode := oFrag.FCode + oFrag.priv1+oFrag.priv2+ '    Public'+EOL_WINDOWS+
               '      destructor Destroy; Override;'+EOL_WINDOWS+
               '      Procedure Assign(oObject : TAdvObject); Override;'+EOL_WINDOWS+
               '      Procedure Define(oFiler : TAdvFiler); Override;'+EOL_WINDOWS+EOL_WINDOWS+
               oFrag.pub;
  oFrag.FCode := oFrag.FCode +'    End;'+EOL_WINDOWS+EOL_WINDOWS;
  If (t > 0) Then
    oFrag.FImpl := oFrag.FImpl+
        'Destructor '+oFrag.FPascalName+'.Destroy;'+EOL_WINDOWS+
        'Begin'+EOL_WINDOWS+
        oFrag.dest+
        '  Inherited;'+EOL_WINDOWS+
        'End;'+EOL_WINDOWS+
        ''+EOL_WINDOWS+
        ''+EOL_WINDOWS+
        'Procedure '+oFrag.FPascalName+'.Assign(oObject : TAdvObject);'+EOL_WINDOWS+
        'Begin'+EOL_WINDOWS+
        '  Inherited;'+EOL_WINDOWS+
        oFrag.ass+
        'End;'+EOL_WINDOWS+
        ''+EOL_WINDOWS+
        ''+EOL_WINDOWS+
        'Procedure '+oFrag.FPascalName+'.Define(oFiler : TAdvFiler);'+EOL_WINDOWS+
        'Begin'+EOL_WINDOWS+
        '  Inherited;'+EOL_WINDOWS+
        oFrag.def+
        'End;'+EOL_WINDOWS+
        ''+EOL_WINDOWS+EOL_WINDOWS
  Else
    oFrag.FImpl := '';
End;


Procedure TIdSoapWSDLToAdvConvertor.DefineParameter(oMethod : TIdSoapITIMethod; oFrag : TIdSoapWSDLPascalFragment; sName : String; sXMLName : String; sNameOfType : String; aType : TFieldType);
Begin
  oFrag.priv1 := oFrag.priv1 + '      F'+sName+' : '+sNameOfType+';'+EOL_WINDOWS;
  If aType = ftClass Then
  Begin
    oFrag.priv2 := oFrag.priv2 + '      Procedure Set'+sName+'(Const oValue : '+sNameOfType+');'+EOL_WINDOWS;
    oFrag.pub := oFrag.pub+'      Property '+sName+' : '+sNameOfType+' read F'+sName+' write Set'+sName+';'+EOL_WINDOWS;
    oFrag.dest := oFrag.dest+'  F'+sName+'.Free;'+EOL_WINDOWS;
    oFrag.def := oFrag.def + '  oFiler['''+sXMLName+'''].DefineObject(F'+sName+', '+sNameOfType+');'+EOL_WINDOWS;
    oFrag.ass := oFrag.ass + '  '+sName+' := '+oFrag.FPascalName+'(oObject).F'+sName+'.Clone;'+EOL_WINDOWS;
    oFrag.FImpl := oFrag.FImpl +
      'Procedure '+oFrag.FPascalName+'.Set'+sName+'(Const oValue : '+sNameOfType+');'+EOL_WINDOWS+
      'Begin'+EOL_WINDOWS+
      '  F'+sName+'.Free;'+EOL_WINDOWS+
      '  F'+sName+' := oValue;'+EOL_WINDOWS+
      'End;'+EOL_WINDOWS+
            ''+EOL_WINDOWS+EOL_WINDOWS;
  End
  Else
  Begin
    oFrag.ass := oFrag.ass + '  '+sName+' := '+oFrag.FPascalName+'(oObject).'+sName+';'+EOL_WINDOWS;
    oFrag.pub := oFrag.pub+'      Property '+sName+' : '+sNameOfType+' read F'+sName+' write F'+sName+';'+EOL_WINDOWS;
    If aType = ftEnum Then
      oFrag.def := oFrag.def + '  oFiler['''+sXMLName+'''].DefineEnumerated(F'+sName+', '+Copy(sNameOfType, 2, $FF)+'NameArray);'+EOL_WINDOWS
    Else If SameText(sNameOfType, 'TDateTime') Then
      oFrag.def := oFrag.def + '  oFiler['''+sXMLName+'''].DefineDateTime(F'+sName+');'+EOL_WINDOWS
    Else If (aType = ftClass) Or ((sNameOfType[1] = 'T') And not SameText(sNameOfType, 'TDateTime')) Then
      oFrag.def := oFrag.def + '  oFiler['''+sXMLName+'''].DefineObject(F'+sName+', '+sNameOfType+');'+EOL_WINDOWS
    Else If SameText(sNameOfType, 'int64') Then
      oFrag.def := oFrag.def + '  oFiler['''+sXMLName+'''].DefineInteger(F'+sName+');'+EOL_WINDOWS
    Else
      oFrag.def := oFrag.def + '  oFiler['''+sXMLName+'''].Define'+sNameOfType+'(F'+sName+');'+EOL_WINDOWS
  End;
End;


(*

  TIdSoapWSDLPascalFragment = Class (TIdBaseObject)
  Private
    FHidden : Boolean;
    FPascalName : String;
    FAncestor : String;
    FTypeType : TIdSoapTypeType;
    FCode : String;
    FDecl : String;
    FImpl : String;
    FReg : String;
    FIncludeInPascal : Boolean;
    FFieldType : TFieldType;
  Public
    Constructor Create;
  End;
*)


End.

