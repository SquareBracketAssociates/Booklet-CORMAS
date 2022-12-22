## Building a Cormas Model from Scratch: the stupid modelStupid model was presented in 2006 in a paper from Railsback _et al._ in the "_Simulation_"" review under the title :"[Agent-based Simulation Platforms:](http://sim.sagepub.com/cgi/content/abstract/82/9/609)". His goal was to propose an ABM step-by-step model in order to  have a standardized way to do benchmark different ABM platforms.In the Railsback _et al_. \(2006\) paper, they test : Netlogo, Masson, Repast, Swarm. We propose here to reimplement the stupid model as an introduction to the CORMAS framework. In this chapter we will follow exactly the scheduler propose in the original paper \(*@stupidUML@*\).![Stupid model UML](figures/stupidModel.png width=60%&label=stupidUML)### Step 1: a grid and some bugs#### Create a package and some classesBefore starting we need to create, a new package for our model. Create a package is made with a right click in the interface package part \(*@createPackage@*\).![Create an empty package for your new model](figures/createPackage.png width=60%&label=createPackage)In this empty package you can add 3 classes \(e.g. *@stupidUML@*\) : CMStupidCell \(for grid cells\), CMStupidAgent, CMStupidModel \(as schedulers\), using the same method \(rigth clik\) but this time in the class part \(*@createclasses@*\). And copy the code below.![Create class](figures/createClasses.png width=60%&label=createclasses)It looks like that for CMStupidCell```CMSpatialEntityCell subclass: #CMStupidCell
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'Cormas-Model-myStupid'```For CMStupidAgent```CMAgentLocation subclass: #CMStupidAgent
	instanceVariableNames: 'agsize'
	classVariableNames: ''
	package: 'Cormas-Model-myStupid'```And for the greate Scheduler```CormasModel subclass: #CMStupideModel
  instanceVariableNames: 'theCMStupidCells theCMStupidAgents numberOfStupidAgent'
  classVariableNames: ''
  package: 'Cormas-Model-myStupid'```In this last class declaration, `theCMStupidCells` and `theCMStupidAgents` are built adding `the` at the beginning and `s` at the end. This instance variable will accede to a list of the concerned entities.#### Methods for StupidCellAt this step you just need one instance method of POV \(point of view\). If you want to visualize some object CORMAS is waiting at least a color.```pov
	^ Color green.```#### Methods for CMStupidAgentYour stupid agent also needs instance methods. But more than one.We want than our agent will be able to move so :```move
	"move to an empty cell... if not don't move"

	self randomWalkConstrainedBy: [
			:c | c noOccupant
		].```As for cell, if you want to visualize your agents, you need to specify their colors :```pov

	^ Color blue```And you can add a dummy scheduler for these classes calling the `move` method.```step

	self move.```#### Methods for StupidModelThe scheduler is a little bite more complicated because you need instance and class methods. Let's go !##### You can initiate with instance methods.You need to create accessors \(*@accessor@*\). Assessor is a way to deal with variable of your class. There, you want accessors for each element of the instance variable list created previously during the class implementation : `theCMStupidCells`, `theCMStupidAgents` and `numberOfStupidAgent` .![Create accessor to your object](figures/createInstanceAccessors.png width=60%&label=accessor)for ` ` you need to do a lasy initialisation to be sure than you always have a number of agent created, because `theCMStupidAgents` will wait a number.```numberOfStupidAgent
	^ numberOfStupidAgent ifNil: [ numberOfStupidAgent := 10 ]```It's time to create a scenario. In this method you will declar the grid size and with neighborhood you want : von Neumann \(4\) or moore \(8\). And you```initWithProgrammableScenario

	self createGridX: 100 Y: 100 neighbourhood: 4 closed: false.
	self setRandomlyLocatedAgents: CMStupidAgent n: self numberOfStupidAgent.```##### you can continu with class methods.Firt we implement a method in order to create a model instance```exampleSM1
	| aModel |
	"self setActiveProbes: OrderedCollection new."
	aModel := self initialize new initSimulation.
	(CMSimulationGrid new
		on: aModel
		withCells: aModel theCMStupidCells
		withSituatedEntities: aModel theCMStupidAgents) runAndVisualizeWithMenus```Cormas is waiting for a default initialization as accessor. So you can create accessor for class variable by right clicking or copy paste the following methods. `defaultInit` will make reference to an instance variable created previously : `initWithProgrammableScenario````defaultInit

	^ defaultInit ifNil: [ defaultInit := #initWithProgrammableScenario ]``````defaultInit: aSelector

	defaultInit := aSelector```![Stupid model, step 1 Done !](figures/stupidModel_step1.png width=60%&label=SMStep1)### Step 2: growing bugs