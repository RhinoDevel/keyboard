# RhinoDevel's Musical Keyboard v1.2
The only musical keyboard for Commodore PET/CBM 8-bit machines with live recording functionality, vibrato and more.

[DOWNLOAD current release v1.2 for BASIC v2 and v4, here!](https://github.com/RhinoDevel/keyboard/releases/download/v1.2/keyboard-v1_2-basic_v2_and_v4.prg)

[DOWNLOAD current release v1.2 for BASIC v1, here!](https://github.com/RhinoDevel/keyboard/releases/download/v1.2/keyboard-v1_2-basic_v1.prg)

![Screenshot of RhinoDevel's Keyboard](/40col-v1_2.jpg?raw=true)

## Why?

This is no tracker (yet?), it is a musical keyboard using the one single sound
channel the PET/CBM user port offers via CB2.

Apart from the 6502/Commodore programming experience for me personally,
this musical keyboard is useful for:

- *Making beautiful, beautiful **music**!*

- **Doing something new with your PET/CBM** (sure, there are a couple of
  programs to make music I know of, but I don't think there is software with
  features like live recording, vibrato effect, etc.).

- **Record** your melody in realtime (instead of using a tracker or something),
  save it to tape and integrate it into your own software/game as background
  music via a simple IRQ routine (the recording frequency equals the IRQ's
  50/60 Hz).

## Features

- **Dynamic note length**: As expected from a musical keyboard, a note will be
                           played as long as you hold down the associated button
                           (if it is the last note button pressed,
                           see "smooth note transition").

- **Smooth note transition**: If the buttons for two musical notes are held down
                              at the same time, the last pressed button's note
                              will be played.
                      
- **17 different sounds**: Choose between all seventeen sounds distinguishable
                           by the human ear and producible with the shift
                           register.
                
- **Effects**: Enable effects like vibrato (in addition to the 17 sounds).
                
- **Record music**: Just play a melody and it will be recorded to memory.

- **Playback your recording**: Let the application play your recorded melody.

- **Increase playback speed**: Playback your music with 1x, 2x, 3x or 4x speed.

- **Loop playback mode**: Let the CBM playback your recorded melody in an
                          infinite loop.

- **Visual feedback**:

  The screen shows the buttons used for the
  **musical keyboard as arranged on your CBM**
  (an exception is the PET 2001 with the chiclet keys).

  The application also shows, which **buttons** are pressed and which
  **functions** are currently enabled.
                   
  The selected **bit pattern** is displayed as graphic.
                   
  The **currently playing note** is displayed as timer hex value.
                   
  The **count of currently stored notes** (and pauses) in memory is displayed as
  hex value and also the **maximum possible count of notes/pauses** storable in
  memory of your CBM.

- **Save tunes to tape**: Save your recorded melody to tape (#1 and #2).

- **Load tunes from tape**: Load tunes from tape (#1 and #2).

- **No special hardware**: If your CBM has an internal beeper or you connected
                           (e.g.) an audio amplifier and speaker to CB2 at the
                           user port, you are good to go.

- **Single binary application**: The same PRG can be used for all supported
                                 CBMs/PETs, 40 or 80 columns, BASIC 2 or 4.

- **Additional BASIC 1 support**: A special BASIC 1 PRG file is available.
                             
- **Re-entry / no reset**:

  You can exit the application and re-enter it without loosing your recorded
  tune.
                       
  In addition, resetting the machine before doing something else with it is not
  necessary.

## Ideas for future improvements

- [ ] Add check, if there is enough memory to record further.

- [ ] Show numbers in **decimal**.

- [ ] Add effect: **"Arpeggio"** (press two note buttons to let the associated
                  musical notes alternate quickly).

- [ ] Optionally save records together with an
      **IRQ-based background music player** to be able to run and play records
      on their own. I already got an IRQ-based player ready (needs some
      polishing before release).

- [ ] Let user modify vibrato effect.

- [ ] Add tracker functionality to edit your recorded tune, etc.

- [ ] Create **library with tunes** (*maybe with YOUR help?*).
      Playing and recording melodies from C64 games would be cool..
              
- [ ] Reduce screen updates to avoid **"snow"** on the PET 2001.

- [ ] **Chiclet keyboard** layout support.

- [ ] **Reduce binary size** by improving source code.

## Successfully tested with

- :smiling_face_with_three_hearts: **CBM 3032** with BASIC v2. :smiling_face_with_three_hearts:
- :heart_eyes: **CBM 8032-SK** with BASIC v4. :heart_eyes:
- :+1: VICE emulator. :+1:

***Please have extreme fun with RhinoDevel's Musical Keyboard !!!***
