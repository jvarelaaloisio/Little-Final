Features 
 
• Shuriken Particle Systems 
• Cloud Scape Generator 
• 10 Cloud Mesh Emitters 
• 8 Different Styles 
• Sample Scenes 
• Particle Scale Tool 
• Particle Material Tool 
 
Some of these particle systems uses two materials to simulate volume. This can impact performance on slow devices. 
Single material versions of the clouds are located in the "Toon Clouds/Prefabs/Singles - One Material" folder. 
 
To get the airplane to fly correctly; overwrite "InputManager.asset" file in "Project Settings" with the zipped "InputManager.asset" file included in "Settings" folder.
"InputManager.asset" contains information about the keys used to control the airplane.
 
The "Cloud Scape Generator" can be used in two ways. 
        1. Generate a single mesh of the cloud scape 
                This method is optimal for performance since the scape only uses one particle system 
         
                • Open the "Toon Clouds SCN Scape Mesh" Scene from "Toon Clouds/Scenes" folder 
                • Select the "Cloud Scape Generator - Mesh" gameObject 
                • Click on the "Generate" button 
                         This will generate cloud "cloudMesh" gameObjects in a random fashion based on the variables 
                • Work with the variables and click the "Generate" button until the cloud suits your needs 
                        Each cloud can be manually moved, scaled or rotated for more accurate results 
                • Click the "Save" button to create a single mesh of the cloud scape 
                        The mesh will be saved in the "Toon Clouds\GeneratedCloudScapes" folder 
                        The "Target Particle System" mesh emitter will automatically be updated to the new mesh 
         
        2. Generate a cloud scape from multiple particle systems 
                This method will look better but not optimal for performance since many particle systems will be used 
                                 
                • Open the "Toon Clouds SCN Scape Particle Puff" Scene from "Toon Clouds/Scenes" folder 
                • Select the "Cloud Scape Generator - Multi Particles - Puff" gameObject 
                • Click on the "Generate" button 
                        This will generate many particle systems in a random fashion based on the variables 
                • Work with the variables and click the "Generate" button until the cloud suits your needs 
                        Each cloud can be manually moved, scaled or rotated for more accurate results 
                        Move overlapping clouds away from each other to avoid the systems from popping in front of 
                        one another (rendering order is based on the closest transform position) 
                • Click the "Save" button to create a prefab of the generated clouds 
                        The prefab will be saved in the "Toon Clouds\GeneratedCloudScapes" folder 
                        The "Target Particle System" is not needed for this method 
                 
                 
 
Particle Scaler Tool 
        • Scale Particles 
                A simple function that helps with scaling all selected particle systems 
        • Create Prefabs 
                Creates prefabs from selected gameObjects 
        • Update Particles 
                Updates all selected particle systems, useful for previewing multiple particle systems 
 
Material Override Tool 
        A tool that makes it possible to attach two materials to a shuriken particle system 
        Can also be used to change from two to one materials 
         
ParticleEditorKiller 
        Un-commenting this script will disable the editor of particle systems and enable multi-editing 
        This is a experimental script that might generate errors if disabled when a particle system is selected.
 
 
 
Unluck Software 
http://www.chemicalbliss.com/ 
 
Thanks for purchasing this asset 
Have fun with Unity!