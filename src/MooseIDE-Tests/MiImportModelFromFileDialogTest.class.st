Class {
	#name : #MiImportModelFromFileDialogTest,
	#superclass : #TestCase,
	#instVars : [
		'dialog',
		'emptyJSONFile',
		'modelJSONFile',
		'modelJsonWithoutMetadata'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #tests }
MiImportModelFromFileDialogTest >> emptyJSONFile [
	| file |
	file := FileSystem memory workingDirectory / 'somefile.json'.
	file writeStreamDo: [ :stream | stream << '{}' ].
	^file
]

{ #category : #running }
MiImportModelFromFileDialogTest >> famixTest1ModelFile [
	"Creating an in-memory JSON file containing a class from FamixTest1Model"

	| file model |
	"model := FamixTest1Model new.
	FamixTest1Class named: 'Class1' model: model."
	model := FamixJavaModel new.
	model newClassNamed: #ClassA.
	model newPackageNamed: #PackageA.
	model newSourceLanguage.

	file := FileSystem memory workingDirectory / 'test1Model.json'.
	file writeStreamDo: [ :stream | model exportToJSONStream: stream ].

	^ file
]

{ #category : #'as yet unclassified' }
MiImportModelFromFileDialogTest >> modelJsonWithoutMetadata [

	| jsonString file |
	jsonString := '[{
	"FM3":"Famix-PharoSmalltalk-Entities.Method",
	"id":1,
	"name":"package:",
	"cyclomaticComplexity":-1,
	"isAbstract":false,
	"isClassSide":false,
	"isStub":true,
	"numberOfConditionals":-1,
	"numberOfLinesOfCode":3,
	"numberOfStatements":-1,
	"protocol":"accessing",
	"signature":"package:(Object)",
	"timeStamp":""
},{
	"FM3":"Famix-PharoSmalltalk-Entities.AnnotationInstance",
	"id":2,
	"annotatedEntity": {"ref": 3},
	"annotationType": {"ref": 4},
	"isStub":false,
	"numberOfLinesOfCode":0
},{
	"FM3":"Famix-PharoSmalltalk-Entities.ImplicitVariable",
	"id":5,
	"name":"self",
	"isStub":false,
	"numberOfLinesOfCode":-1,
	"parentBehaviouralEntity": {"ref": 6}
}]'.

	file := FileSystem memory workingDirectory / 'test2Model.json'.
	file writeStreamDo: [ :stream | stream nextPutAll: jsonString ]. 
	
	^ file 
	
]

{ #category : #running }
MiImportModelFromFileDialogTest >> setUp [

	super setUp.

	modelJSONFile := self famixTest1ModelFile.
	emptyJSONFile := self emptyJSONFile.
	modelJsonWithoutMetadata := self modelJsonWithoutMetadata .

	dialog := MiImportModelFromFileDialog new
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathSelectMetadata [

	(dialog presenterAt: #mooseModelDroplist)
		addItemLabeled: FamixJavaModel
		do: [  ].


	dialog updateForModelFile: modelJSONFile.

	self
		assert: (dialog presenterAt: #mooseModelDroplist) selectedItem
		equals: FamixJavaModel.


	self
		assert: (dialog presenterAt: #modelNameInput) text
		equals: 'noname'.


	(dialog presenterAt: #modelNameInput) text: 'test1Model'.

	self
		assert: (dialog presenterAt: #modelNameInput) text
		equals: 'test1Model'
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathSelectsAppropriateMetaModel [

	dialog updateForModelFile: modelJSONFile.

	self
		assert: (dialog presenterAt: #mooseModelDroplist) selectedItem
		equals: FamixJavaModel
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathUpdatesFilePathInput [

	dialog updateForModelFile: emptyJSONFile.

	self
		assert: (dialog presenterAt: #filePathInput) text
		equals: emptyJSONFile pathString
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathUpdatesModelName [

	dialog updateForModelFile: emptyJSONFile.

	self
		assert: (dialog presenterAt: #modelNameInput) text
		equals: emptyJSONFile basenameWithoutExtension
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathUpdatesRootFolderInput [

	dialog updateForModelFile: emptyJSONFile.

	self
		assert: (dialog presenterAt: #rootFolderInput) text
		equals: emptyJSONFile parent pathString
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testAddingFilePathWithoutAppropriateMetaModel [

	self
		should: [ dialog updateForModelFile: modelJSONFile ]
		raise: Error
]

{ #category : #tests }
MiImportModelFromFileDialogTest >> testMetadataNotPresent [

	(dialog presenterAt: #mooseModelDroplist)
		addItemLabeled: FamixJavaModel
		do: [  ].


	dialog updateForModelFile: modelJsonWithoutMetadata.
	self
		assert: (dialog presenterAt: #mooseModelDroplist) selectedItem
		equals: FamixJavaModel.

	

]
