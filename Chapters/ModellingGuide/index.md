## A first step in modelling and simulation

Bommel, P. (2009). « Définition d’un cadre méthodologique pour la conception de mo-
dèles multi-agents adaptée à la gestion des ressources renouvelables ». Thèse de doct.
Université Montpellier II-Sciences et Techniques du Languedoc.

Delay, E. « Réflexions géographiques sur l’usage des systèmes multi-agents dans la compréhension des processus d’évolution des territoires viticoles de fortes pentes : Le cas de la Côte Vermeille et du Val di Cembra » (Thèse de doctorat, Limoges, Université de Limoges, 2015).

Edmonds B. et al., « Different Modelling Purposes », Journal of Artificial Societies and Social Simulation 22, nᵒ 3 (2019): 6.

Rey-Coyrehourcq, S., « Une plateforme intégrée pour la construction et l’évaluation de modèles de simulation en géographie » (doctorat, Paris, Panthéon Sorbonne, 2015), https://hal.science/tel-01652092.

### Models and agents based models

#### What is modelling

#### Models roles and status

##### Modeling to predict

##### Modéliser pour comprendre

#### The controversy between reductionism and holism: a 3rd way, complexity

#### Agents and multi-agent systems

![Open Cormas-UI](figures/Diapositive2.png label=Diapositive2)
![Open Cormas-UI](figures/Diapositive3.png label=Diapositive3)
![Open Cormas-UI](figures/Diapositive4.png label=Diapositive4)
![Open Cormas-UI](figures/Diapositive5.png label=Diapositive5)
![Open Cormas-UI](figures/Diapositive6.png label=Diapositive6)
![Open Cormas-UI](figures/Diapositive7.png label=Diapositive7)
![Open Cormas-UI](figures/Diapositive8.png label=Diapositive8)
![Open Cormas-UI](figures/Diapositive9.png label=Diapositive9)
![Open Cormas-UI](figures/Diapositive10.png label=Diapositive10)
![Open Cormas-UI](figures/Diapositive11.png label=Diapositive11)
![Open Cormas-UI](figures/Diapositive12.png label=Diapositive12)

#### Model validation



### Why choose Cormas and Pharo ?



### Downloading and installing for your platform



#### Windows

#### Mac

#### Linux 


### The UI of Cormas


The main window of Cormas-UI can be open from the world contextual menu \(fig. *@openCormasUI@*\).
![Open Cormas-UI](figures/openCormasUI.png label=openCormasUI)

To open a model which already exists in your current image select File>Open>Local image, then choose one of the available models

The model is loaded as the current Cormas project and the simulation window appears \(fig. *@simulationWindow@*\).
![Open Cormas-UI](figures/simulationWindow.png label=simulationWindow)

Simulation window > Button 1 : Define a scenario and initialize the simulation 
Simulation window > Button 2 : Run one step \(the simulation needs to be initialized first\)
Simulation window > Button 3 : Run the simulation until the final step \(the simulation needs to be initialized first\)
Simulation window > Field A : Current time step of the simulation \(cannot be edited\)
Simulation window > Field B : Final step of the simulation \(can be edited by the user\)

#### Launch a simulation and follow it run using the probes chart window

1/ Define a scenario and initialize the simulation
Click the Initiliaze button \(n°1 in fig. *@simulationWindow@*\).

The scenario window opens \(fig. [@defineScenarioWin\).](figures/defineScenarioWin.png) The defaultInit, defaultControl, defaultFinalStep and defaultProbes are selected when the window opens. Their values  can be defined by selectors at the CormasModel class side.
Click Apply

The simulation is now initialize. The current time step is zero. The simulation can be run.

Launch the simulation either using 'Step by step' button \(n°2 in fig. *@simulationWindow@*'\) or by using the run button \(n°3 in fig. *@simulationWindow@*'\).

To open the probes chart window select 'Visualization>Probes' from Cormas-UI main window. 

The chart window is updated at each step and reset when the simulation is re-initialized.



### The Pharo Playground and Browser
