#tag Class
Protected Class FloatingLabelTextArea
Inherits WebSDKUIControl
	#tag Event
		Sub DrawControlInLayoutEditor(g As Graphics)
		  // Define colors depending on light/dark mode
		  Var bgColor As Color
		  Var borderColor As Color
		  Var labelColor As Color
		  Var inputColor As Color
		  Var disabledColor As Color
		  
		  If IsDarkMode Then
		    // Dark mode: Bootstrap dark theme approximated
		    bgColor = &c212529
		    borderColor = &c495057
		    labelColor = &cADB5BD
		    inputColor = &cFFFFFF
		    disabledColor = &c2C3034
		  Else
		    // Light mode: Bootstrap default theme
		    bgColor = &cFFFFFF
		    borderColor = &cCED4DA
		    labelColor = &c6C757D
		    inputColor = &c000000
		    disabledColor = &cF0F0F0
		  End If
		  
		  // Draw background
		  g.DrawingColor = bgColor
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  
		  // Draw border
		  g.DrawingColor = borderColor
		  g.PenSize = 1
		  g.DrawRectangle(0, 0, g.Width - 1, g.Height - 1)
		  
		  // Disabled overlay
		  If Not BooleanProperty("Enabled") Then
		    g.DrawingColor = disabledColor
		    g.FillRectangle(0, 0, g.Width, g.Height)
		  End If
		  
		  // Floating label
		  g.FontSize = 10
		  g.DrawingColor = labelColor
		  Var label As String = ""
		  Try
		    label = StringProperty("LabelText")
		  Catch
		    label = "Label"
		  End Try
		  g.DrawText(label, 8, 12)
		  
		  // Input value (multi-line text area)
		  g.FontSize = 12
		  g.DrawingColor = inputColor
		  Var value As String = ""
		  Try
		    value = StringProperty("Value")
		  Catch
		    value = ""
		  End Try
		  g.DrawText(value, 8, 28, g.Width - 16) // automatic line wrapping
		End Sub
	#tag EndEvent

	#tag Event
		Function ExecuteEvent(name As String, parameters As JSONItem) As Boolean
		  Select Case name
		  Case "TextChanged"
		    Value = parameters.Value("value")
		    RaiseEvent TextChanged(Value)
		    Return True
		  End Select
		  
		  Return False
		End Function
	#tag EndEvent

	#tag Event
		Function HandleRequest(request As WebRequest, response As WebResponse) As Boolean
		  // This event is similar to the Application.HandleURL event,
		  // except it will only be triggered on this control instance
		  // specific URL.
		  //
		  // The URL will needs to have the format /sdk/<ControlID>
		  //
		  // For example, if our domain is "example.org"
		  // and the control instance ID is "gNWJcv", the URL
		  // will be: https://example.org/sdk/gNWJcv
		  //
		  // You can use this event to populate an HTML table,
		  // dynamically, in a request-response manner. The response
		  // will normally be some JSON encoded data.
		  //
		  // If you are handling this request, you will need to
		  // Return True.
		  //
		  // In case your control isn't expecting a response, it's
		  // probably more appropiate to use ExecuteEvent instead.
		  //
		  // While we won't use this event in this example, we are
		  // implementing it anyway, so the user doesn't see it in the
		  // list of events available to implement.
		End Function
	#tag EndEvent

	#tag Event
		Function JavaScriptClassName() As String
		  // We will need to return a String like <namespace>.<className>.
		  // This should match with the name you're using in your
		  // JavaScript code. See the constant kJavaScriptCode for the
		  // source.
		  //
		  // Every control needs to use a namespace, to avoid collisions
		  // between other third party controls. In this case, we will
		  // be using "Example".
		  //
		  // There are reserved namespaces, like "Xojo".
		  //
		  // Please check the "WebSDK Docs.pdf" document included in
		  // your Xojo installation folder for more information about
		  // namespaces.
		  
		  Return "FAESCH.FloatingLabel.FloatingLabelTextArea"
		End Function
	#tag EndEvent

	#tag Event
		Sub Serialize(js As JSONItem)
		  js.Value("value") = Value
		  js.Value("placeholder") = " " // Required for floating label
		  js.Value("labelText") = EncodeBase64(EncodeURLComponent(LabelText))
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function SessionCSSURLs(session As WebSession) As String()
		  // This WebFile instance will be shared between every instance.
		  // If it doesn't exists, we'll have to create. This will happen
		  // just once.
		  If CSSCodeWebFile = Nil Then
		    CSSCodeWebFile = New WebFile
		    
		    // Here we'll insert the code from our constant.
		    CSSCodeWebFile.Data = kCSSCode
		    
		    // As this instance will be shared between every session,
		    // it's important to set this parameter to Nil. Otherwise,
		    // only the first session will be able to download this file.
		    CSSCodeWebFile.Session = Nil
		    
		    // Add a file name and the proper mime type.
		    CSSCodeWebFile.Filename = "FloatingLabelTextField.css"
		    CSSCodeWebFile.MIMEType = "text/css"
		  End If
		  
		  // Finally, we just need to return the array of required files.
		  // In this example we just need one. If you are integrating a
		  // third-party library, maybe you'll need to include a URL
		  // from a external server. In that case, a full URL is also
		  // valid.
		  Return Array(CSSCodeWebFile.URL)
		End Function
	#tag EndEvent

	#tag Event
		Function SessionHead(session As WebSession) As String
		  // This event fires each time a new session starts. You should
		  // return a String containing the items you wish to add to the
		  // <head> tag.
		  //
		  // While we won't use this event in this example, we are
		  // implementing it anyway, so the user doesn't see it in the
		  // list of events available to implement.
		End Function
	#tag EndEvent

	#tag Event
		Function SessionJavascriptURLs(session As WebSession) As String()
		  // This WebFile instance will be shared between every instance.
		  // If it doesn't exists, we'll have to create. This will happen
		  // just once.
		  If JavaScriptCodeWebFile = Nil Then
		    JavaScriptCodeWebFile = New WebFile
		    
		    // Here we'll insert the code from our constant.
		    JavaScriptCodeWebFile.Data = kJavaScriptCode
		    
		    // As this instance will be shared between every session,
		    // it's important to set this parameter to Nil. Otherwise,
		    // only the first session will be able to download this file.
		    JavaScriptCodeWebFile.Session = Nil
		    
		    // Add a file name and the proper mime type.
		    JavaScriptCodeWebFile.Filename = "FloatingLabelTextField.js"
		    JavaScriptCodeWebFile.MIMEType = "application/javascript"
		  End If
		  
		  // Finally, we just need to return the array of required files.
		  // In this example we just need one. If you are integrating a
		  // third-party library, maybe you'll need to include a URL
		  // from a external server. In that case, a full URL is also
		  // valid.
		  Return Array(JavaScriptCodeWebFile.URL)
		End Function
	#tag EndEvent


	#tag Hook, Flags = &h0
		Event TextChanged(Value as String)
	#tag EndHook


	#tag Property, Flags = &h21
		Private Shared CSSCodeWebFile As WebFile
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared JavaScriptCodeWebFile As WebFile
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			t
		#tag EndNote
		#tag Getter
			Get
			  Return mLabelText
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mLabelText = value
			  UpdateControl
			End Set
		#tag EndSetter
		LabelText As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mLabelText As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mValue As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mValue
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mValue = value
			  UpdateControl
			End Set
		#tag EndSetter
		Value As String
	#tag EndComputedProperty


	#tag Constant, Name = kCSSCode, Type = String, Dynamic = False, Default = \".form-floating {\n  width: 100%;\n}\n\n.form-floating > textarea {\n  height: 100%;\n  padding: 1rem .75rem;\n  font-size: 1rem;\n  line-height: 1.25;\n}\n\n.form-floating > label {\n  position: absolute;\n  top: 0;\n  left: 0;\n  height: 100%;\n  padding: 1rem .75rem;\n  pointer-events: none;\n  transition: all 0.1s ease-in-out;\n  color: #6c757d;\n}\n\n.form-floating > textarea:focus ~ label\x2C\n.form-floating > textarea:not(:placeholder-shown) ~ label {\n  transform: scale(0.85) translateY(-0.75rem);\n  color: #495057;\n}", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kJavaScriptCode, Type = String, Dynamic = False, Default = \"var FAESCH \x3D FAESCH || {};\nFAESCH.FloatingLabel \x3D FAESCH.FloatingLabel || {};\n\n(function(ns) {\n  class FloatingLabelTextArea extends XojoWeb.XojoVisualControl {\n    constructor(id\x2C events) {\n      super(id\x2C events);\n      const el \x3D this.DOMElement();\n\n      this.inputGroup \x3D document.createElement(\"div\");\n      this.inputGroup.className \x3D \"form-floating\";\n\n      this.textAreaEl \x3D document.createElement(\"textarea\");\n      this.textAreaEl.className \x3D \"form-control\";\n      this.textAreaEl.id \x3D id + \"_textarea\";\n      this.textAreaEl.placeholder \x3D \" \";\n\n      this.labelEl \x3D document.createElement(\"label\");\n      this.labelEl.setAttribute(\"for\"\x2C this.textAreaEl.id);\n      this.labelEl.innerText \x3D \"Label\";\n\n      this.textAreaEl.addEventListener(\"input\"\x2C () \x3D> {\n        this.triggerServerEvent(\"TextChanged\"\x2C { value: this.textAreaEl.value });\n      });\n\n      this.inputGroup.appendChild(this.textAreaEl);\n      this.inputGroup.appendChild(this.labelEl);\n      el.appendChild(this.inputGroup);\n    }\n\n    updateControl(data) {\n      super.updateControl(data);\n      const json \x3D JSON.parse(data);\n\n      if (typeof json.value !\x3D\x3D \"undefined\") {\n        this.textAreaEl.value \x3D json.value;\n      }\n\n      if (typeof json.placeholder !\x3D\x3D \"undefined\") {\n        this.textAreaEl.placeholder \x3D json.placeholder;\n      }\n\n      if (typeof json.labelText !\x3D\x3D \"undefined\") {\n        this.labelEl.innerText \x3D decodeURIComponent(atob(json.labelText));\n      }\n\n      if (typeof json.enabled !\x3D\x3D \"undefined\") {\n        this.textAreaEl.disabled \x3D !json.enabled;\n      }\n\n      this.refresh();\n    }\n\n    render() {\n      super.render();\n      const el \x3D this.DOMElement();\n      if (!el) return;\n\n      // Set the height of the textarea to match the control\'s height\n      this.textAreaEl.style.height \x3D el.offsetHeight + \"px\";\n\n      this.setAttributes();\n      this.applyUserStyle();\n      this.applyTooltip(el);\n    }\n  }\n\n  ns.FloatingLabelTextArea \x3D FloatingLabelTextArea;\n})(FAESCH.FloatingLabel);", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="38"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockHorizontal"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockVertical"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LabelText"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Visual Controls"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Visual Controls"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Indicator"
			Visible=true
			Group="Visual Controls"
			InitialValue=""
			Type="WebUIControl.Indicators"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - Primary"
				"2 - Secondary"
				"3 - Success"
				"4 - Danger"
				"5 - Warning"
				"6 - Info"
				"7 - Light"
				"8 - Dark"
				"9 - Link"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="PanelIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_mPanelIndex"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ControlID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="_mName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
