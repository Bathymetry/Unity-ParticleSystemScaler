Unity-ParticleSystemScaler
==========================
This is a run-time way to scale Particle Systems in Unity.

How-To-Use

(1) Attach the ParticleSystemScaler script to all Particle System Objects that you wish to scale at run-time. (this script must be included on all Particle System sub-objects in the transform hierarchy of the root system,
(2) Use the shaders included (or write/modify your own using them as a base)


At runtime call something like the following on your root particle system to scale it dynamically at runtime:

<root_object>.ParticleSystemScale = new Vector3(xScale,yScale,zScale);