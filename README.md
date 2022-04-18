# ECE6255-team-project
# Arbitrary Modification of Speech Characteristics in Segmental Durations

Kyeomeun Jang, Jiaying Li, Yinuo Wang 

April, 2022

## Instructions
* For **Developers**, the `project.m` is the main script of the whole project, and `seg_modify.m` is the main function to realize the segment modification in th time domain.
  
  Running Examples of Calling seg_modify function:
    * **Modify a single segment([0.5,1])'s length in the speech to 2s**
    
      out = seg_modify(speech,"SOLAFS", 0.5, 1.0, 2.0, "duration");

    * **Modify three segments in the speech with different scaling factors**
      
      t1 = [0.5, 1.0, 2.0];\
      t2 = [0.88, 1.5, 3.0];\
      target = [1.0, 1.5, 0.5];\
      out = seg_modify(speech, "SOLAFS", t1, t2, target, "scaling");


* For **Users**, please run the `ProjectGUI.m` to launch the graphical tool. 
  ![image](https://github.com/allenwang-git/ECE6255-team-project/blob/main/Media/GUI.png)

  As a user, you can load any audio file to the tool by clicking the `Select Your File` button. Our program provides two different modification mode, in the "duration" mode, you may want to give the desired duration length of the selected segments and in the "scaling" mode, you just need to specify the scaling factors of every selected segment. 
  
  Users can also select one of the three algorithms (SOLAFS, WSOLA, Phase Vocoder) provided in the tool. To apply such configuration, please click the `INPUT` button to load it to the program.
  
  To modify the segments with your desired parameters, you can simply click the `Modify` button and you will see the modified audio waveform and spectrugram plotted in the second column. In addtion, you can play or save the modified speech if you want.



## Algorithms
  + Time Domain
    + -[ ] SOLA
    + -[X] SOLAFS
    + -[ ] TD-PSOLA
    + -[X] WSOLA (https://www.mathworks.com/help/audio/ref/stretchaudio.html#mw_af8e9d0f-683d-4593-8776-f3588a02959f)
  + Frequency Domain
    + -[ ] LSEE-MSTFTM
  + Parameter Method
    + -[x] Phase Vocoder
    + -[ ] Sinusoidal Modeling

## Supplements

Report Link: https://gtvault-my.sharepoint.com/:w:/g/personal/jli3269_gatech_edu/EZrfg3MLlYFGkZSQJ6Ukuw0BX_Ep6KfD1HzVqqhLUFnhDg?e=p4ulpW

Presentation Slide Link: https://gtvault-my.sharepoint.com/:p:/g/personal/jli3269_gatech_edu/EYa9vuexnOpClARAEEeAlF0BR2klbcrgY6NbsxIlgjLXXA?e=Ez3NWk

