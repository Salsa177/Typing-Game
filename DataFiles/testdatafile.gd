class_name PromptFile extends Node

var diff: int

var DefineDef: PackedStringArray = "Define: State meaning and identify essential qualities".split(" ", 0)
var DescribeDef: PackedStringArray = "Describe: Provide characteristics and features".split(" ", 0)
var ExplainDef: PackedStringArray = "Explain: Relate cause and effect; make the relationships between things evident; provide why and/or how".split(" ", 0)
var AnalyseDef: PackedStringArray = "Analyse: Identify components and the relationship between them; draw out and late implications".split(" ", 0)
var JustifyDef: PackedStringArray = "Justify: Support an argument or conclusion".split(" ", 0)
var EvaluateDef: PackedStringArray = "Evaluate: Make a judgement based on criteria; determine the value of".split(" ", 0)

var DefineExample: PackedStringArray = "Define: The computer has Microsoft Office 365, which has programmes such as Word, Excel, Access and PowerPoint in it. Internet Explorer and Chrome are also there, which serve as its main web browsers".split(" ", 0)
var DescribeExample: PackedStringArray = "Describe: The computer runs Office 365, Chrome, Internet Explorer, etc. They are all applications which are pre-installed on the computer. Chrome and Internet Explorer are web browsers that allow access to Office 365, e-mail, ManageBac etc. Office 365 is on the computer, though it can also run through a web browser, meaning you can access it at any time, anywhere".split(" ", 0)
var ExplainExample: PackedStringArray = "Explain: The applications Office 365, Internet Explorer and Chrome are on the computers. Office 365 contains applications such as Word, Excel and Access which are available both at school and online through Internet Explorer and Chrome. Internet Explorer and Chrome are both web browsers, which are not only used to provide access to Office 365, but also to information and YouTube videos to help with assessments from anywhere, at any time".split(" ", 0)
var AnalyseExample: PackedStringArray = "Analyse: Office 365, Internet Explorer and Chrome are on the computers. Internet Explorer and Chrome are both web browsers, which provide a graphical interface to the information and content available online. Some of that content includes but is not limited to the Office 365 application suite,allowing students to access Word, Excel, PowerPoint etc anywhere, anytime. These are accessible inside the Office 365 interface through easily-identifiable web-based versions of these applications; the computer-based versions of these applications are more powerful".split(" ", 0)
var JustifyExample: PackedStringArray = "Justify: Office 365, Internet Explorer and Chrome are on the computers. Internet Explorer and Chrome are both web browsers, which provide a graphical interface to the information and content available online. Some of that content includes but is not limited to the Office 365 application suite,allowing students to access Word, Excel, PowerPoint etc anywhere, anytime. This easy access allows students tocomplete school assessments and tasks without being in any way, shape or form disadvantaged by needing to have the Office suite installed on their own computers, behaving much like the applications on the desktop machines atschool. ".split(" ", 0)
var EvaluateExample: PackedStringArray = "Evaluate: Office 365, Internet Explorer and Chrome are on the computers. Internet Explorer and Chrome are both web browsers, which provide a graphical interface to the information and content available online. Some of that content includes but is not limited to the Office 365application suite, allowing students to access Word, Excel, PowerPoint etc anywhere, anytime. This easy accessallows students to complete school assessments and tasks without being in any way, shape or form disadvantaged by needing to have the Office suite installed on their own computers, behaving much like the applications on thedesktop machines at school. The main advantage of this open access is the reduction in gaps between those who have access to the Office suite and those who do not, meaning less excuses for those who may have used this lackof access in the past. However, this also may reduce skill sets or exposure to other application suites such asOpenOffice which some may perceive as a failing of being homogenous. ".split(" ", 0)

var Beginner_prompt1: PackedStringArray = "Programming".split(" ", 0)
var Beginner_prompt2: PackedStringArray = "Python".split(" ", 0)
var Beginner_prompt3: PackedStringArray = "JavaScript".split(" ", 0)
var Beginner_prompt4: PackedStringArray = "Object-Orientated".split(" ", 0)
var Beginner_prompt5: PackedStringArray = "Visual Studio Code".split(" ", 0)

var Intermediate_prompt1: PackedStringArray = "Programming is really fun and enjoyable".split(" ", 0)
var Intermediate_prompt2: PackedStringArray = "Object-Orientated Paradigm is a smart way to structure code".split(" ", 0)
var Intermediate_prompt3: PackedStringArray = "Visual Studio Code is a great coding workspace".split(" ", 0)

var Advanced_prompt1: PackedStringArray = "Programming is really fun and enjoyable. It allows me to bring my creative visions to life using critical thinking skills logic-based systems. If it wern't for programming, I would be scrolling mindlessly on TikTok".split(" ", 0)
var Advanced_prompt2: PackedStringArray = "Object-Orientated Paradigm is a smart way to structure code. It groups code that have similar needs into classes and subclasses, where the main class carry's all the shared processes, and subclasses have more specific functions".split(" ", 0)
var Advanced_prompt3: PackedStringArray = "Visual Studio Code is a great coding workspace. It is a simplified, compact and aesthetically pleasing piece of software that has all my coding needs in one place. It also allows for community members to create and share extensions to increase productivity".split(" ", 0)

var difficulty_array: Array

var rng := RandomNumberGenerator.new()


func RNG_prompt(difficulty: int) -> int:
	var beginner_array: Array = [Beginner_prompt1, Beginner_prompt2, Beginner_prompt3, Beginner_prompt4, Beginner_prompt5]
	var intermediate_array: Array = [Intermediate_prompt1, Intermediate_prompt2, Intermediate_prompt3, DefineDef,
		DescribeDef, JustifyDef, EvaluateDef, AnalyseDef, ExplainDef]
	var advanced_array: Array = [DescribeExample, DefineExample, Advanced_prompt1, Advanced_prompt2, Advanced_prompt3]
	var professional_array: Array = [ExplainExample, AnalyseExample]
	var master_class_array: Array = [JustifyExample, EvaluateExample]
	
	
	if difficulty == 1:
		difficulty_array = beginner_array
	elif difficulty == 2:
		difficulty_array = intermediate_array
	elif difficulty == 3:
		difficulty_array = advanced_array
	elif difficulty == 3:
		difficulty_array = professional_array
	elif difficulty == 5:
		difficulty_array = master_class_array
	
	var random_prompt_index := rng.randi_range(0, (difficulty_array.size() - 1))
	return random_prompt_index
