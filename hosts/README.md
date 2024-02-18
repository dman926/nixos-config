# Hosts

| Hostname |         System          |             Notes             |
| :------- | :---------------------: | :---------------------------: |
| Quark    |     Live CD/USB ISO     |     Minimal installation      |
| Electron | Framework 13 - 12th gen |                               |
| Neutron  |      Framework 16       | Not tested - awaiting device  |
| Hydrogen |         Desktop         | Multi-monitor<br>CUDA enabled |

## Not managed by NixOS

| Hostname  |       System        |   |
| :-------- | :-----------------: | - |
| Hydroxide | Dell PowerEdge R720 | I will probably switch it to NixOS at some point. I've seen some discussions on NixOS as a hypervisor, and that's pretty cool |

## Naming pattern

Systems follow a chemical "heirarchy" of system complexity and power, with the chemical counterpart following particle/molecule mass and complexity accordingly. The general naming scheme is as follows

| System Type  | Chemical Counterpart                   |
| ------------ | -------------------------------------- |
| IoT/SoC/Edge | Elementary particles                   |
| Laptop       | Composite particles (and the electron) |
| Desktop      | Elements                               |
| Server       | Compounds                              |

Only one hostname should be used at a time. Names can be recycled as they are freed.
