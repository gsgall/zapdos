# EFieldMagnitudeSource

!syntax description /Kernels/EFieldMagnitudeSource

## Overview

`EFieldMagnitudeSource` adds the magnitude of the electric field squared as a source term. 

The source term is defined as

\begin{equation}
S_{\lvert E \rvert} = \lVert \vec{E} \rVert_{2}
\end{equation}

Where $S_{\lvert E \rvert}$ is the source term and $\vec{E}$ is the electric field.

!alert warning title=Untested Class
The EFieldMagnitudeSource does not have a formalized test, yet. For this reason,
users should be aware of unforeseen bugs when using EFieldMagnitudeSource. To
report a bug or discuss future contributions to Zapdos, please refer to the
[Zapdos GitHub Discussions page](https://github.com/shannon-lab/zapdos/discussions).
For standards of how to contribute to Zapdos and the MOOSE framework,
please refer to the [MOOSE Contributing page](framework/contributing.md).

## Example Input File Syntax

!! Describe and include an example of how to use the EFieldMagnitudeSource object.

```text
[Kernels]
  [Source]
    type = EFieldMagnitudeSource
    variable = source
    potential = potential
  []
[]
```

!syntax parameters /Kernels/EFieldMagnitudeSource

!syntax inputs /Kernels/EFieldMagnitudeSource

!syntax children /Kernels/EFieldMagnitudeSource
