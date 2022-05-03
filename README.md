# TrackRat

Tracks a rat in a video of a bottom-up view of a cylindrical chamber with a clear base using a heuristic approach. Asks user to locate the rat and the chamber on the first frame and uses that data to iteratively find the position in the next frame. Converts the video to black and white, thresholds the frame to find the body of the rat, then determines the location of the nose and orientation of the body. See Example.avi for example tracking. Used for [Hartmann et al. 2016](https://www.jneurosci.org/content/36/8/2406.long).

[1] Hartmann K, Thomson EE, Zea I, **Yun R**, Mullen P, Canarick J, Huh A, Nicolelis MA. Embedding a Panoramic Representation of Infrared Light in the Adult Rat Somatosensory Cortex through a Sensory Neuroprosthesis. J Neurosci. 2016 Feb 24;36(8):2406-24. doi: 10.1523/JNEUROSCI.3285-15.2016.

<p align="center">
  <img width="455" height="465" src="https://github.com/richyyun/Tracking/blob/main/Example.PNG">
</p>


