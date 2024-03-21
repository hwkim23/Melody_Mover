# Melody Mover: Musical Cueing to Keep People Moving

A smartphone-based auditory cueing solution for Parkinson’s patients struggling with mobility.

Objective:

Patients with Parkinson’s disease have limited accessible, self-operable, non-pharmacologic solutions available to address their progressive mobility concerns. Our objective is to meet this need and demonstrate a 50% increase in daily steps taken through a mobile phone application that provides intelligent auditory cueing to reduce gait abnormalities and freezing and provides a virtual community to encourage continued exercise.

Background:

Parkinson’s disease is the second most common neurodegenerative disease in the world, with an estimated 1 million individuals affected in the US alone1. It is a progressive disorder marked by the degeneration of cells in the brain responsible for synthesizing dopamine, a critical neurotransmitter responsible for movement. Without dopamine, patients move when they don’t want to (tremors) and can’t move when they do (akinesia). The latter symptom is largely responsible for the reduced quality of life in this patient population. Treatment consists of several extremely effective medications; however, as the disease progresses, medications become less effective, and behavioral self-management strategies are needed.

Cueing is one such approach. A cue is a discrete target or reference for the execution of movement. The beat of a song, for example, can be a cue for the timing of gait in Parkinson’s patients. A laser line placed on the floor is another cue over which a patient will try to step to guide stride length. The idea is that by taking a blocked movement and reframing it (matching a beat or crossing a line instead of walking), you are tapping into a slightly different and less broken part of the brain.

Nuclear studies have shown this effect. Cueing increases activity in compensatory neural circuits less affected by Parkinson’s disease and enhances task performance. Neural circuits responsible for switching between automatic and attention-controlled behavior are particularly affected by PD. An external cue helps switch to attention-controlled gait when automatic gait fails during akinesia4.

Cueing is not only beneficial in overcoming freezing but may lead to greater benefits as it facilitates movement and exercise. Exercise has been shown to improve balance and mobility in PD patients as well as depression, constipation, and cognition. Given this benefit, researchers have asked how to initiate the best and sustained exercise routines in this population. Having adequate support and encouragement has emerged as an important factor.

European guidelines strongly recommend cueing for the treatment of PD. A review of studies including 324 subjects demonstrated decreased freezing and improved gait timing with cueing. Despite these benefits, cueing strategies are often DIY and unsophisticated. Patients may use walkers with laser-projected lines, metronomes, or homemade playlists to cue. Recent studies have demonstrated benefits with more sophisticated and nuanced cues. Action-relevant cues, such as the sound of a footfall, are more effective than standard metronome cues. Intelligent cues, timed to rescue freezing or anticipate it, are more effective than continuous cues. Custom cues, that preserve the biological variability of interstride intervals, are more likely to prevent falls than fixed cues4. Given these findings, there is an opportunity to develop an improved cueing platform for PD patients to overcome freezing and facilitate movement and exercise.




# Usage & Installation


## Prerequisites

Before you begin, ensure that you have Flutter installed on your system. If you haven't installed Flutter yet, please follow the installation guide here: [Flutter Install](https://flutter.dev/docs/get-started/install).

## Getting Started

1. **Clone the Repository**

   First, clone the repository to your local machine using Git.

   ```bash
   git clone [repository URL]
   cd melody_mover
   ```

2. **Flutter Doctor**

   Ensure that all your Flutter dependencies are up to date and properly configured.

   ```bash
   flutter doctor
   ```

3. **Flutter Upgrade**

   It's crucial to have the latest version of Flutter. Run the following command to upgrade Flutter to the latest version.

   ```bash
   flutter upgrade
   ```

4. **Get Dependencies**

   Run the following command to fetch all the required dependencies listed in the `pubspec.yaml` file.

   ```bash
   flutter pub get
   ```

5. **Generate Launcher Icons and Splash Screen**

   To generate custom launcher icons and splash screen for both Android and iOS platforms, run:

   ```bash
   flutter pub run flutter_launcher_icons:main
   flutter pub run flutter_native_splash:create
   ```

6. **Run the Application**

   After all dependencies are fetched, and assets are generated, you can run the application on a connected device or an emulator.

   ```bash
   flutter run
   ```

## Troubleshooting

If you encounter any issues during the setup or while running the application, ensure that:

- Your Flutter environment is set up correctly.
- You have run `flutter pub get` to download all dependencies.
- You are using a supported version of the Dart SDK as specified in `pubspec.yaml`.

For further assistance, consult the Flutter documentation or reach out to the Flutter community.

