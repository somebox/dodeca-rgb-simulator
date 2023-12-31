# DodecaRGB Simulator 

<img width="700" alt="Screenshot 2023-08-30 at 17 14 24" src="https://github.com/somebox/dodeca-rgb-simulator/assets/7750/26a079d8-aabb-4b0e-907a-5e34e593b98c">

 DodecaRGB is an interactive light gadget assembled from 12 PCBs with addressable LEDs. Once put
 together, the model can be programmed to do animations or other things. The prototype was
 developed for CCC Camp 2023 in Germany, and some early kits were sold. 

<img width="500" alt="photo of dodecahedron LED model" src="https://github.com/somebox/dodeca-rgb-simulator/assets/7750/7173f4cf-216a-431c-add5-cadc7f9385f9">
 
 A dodecahedron is a 3d shape with 12 sides, each side is a pentagon made up of 5 equal edges.
 The top and bottom of the pentagon are parallel. 
 
 All of the LEDs are connected in a continuous strand, and each PCB has inputs and outputs on 
 each side (labeled A-E), which need to be connected together in a specific order. This sketch
 helped in figuring out how to best do that and work out the math involved.

 This Processing sketch renders the DodecaRGB model in 3D, with the layout of LEDs and 
 sides numbered. There is a menu displayed and a few options to change the view mode and write
 the data file (if not present).
 
 This sketch can output the points with calculated X,Y,Z coordiates for all 312 LEDs (26 per side), 
 both as a JSON file and a C++ header file containing an array. This is useful for
 programming the firmware and developing your own animations.

 Requires Processing v4.3 or later

 References:
 - Hackaday page: https://hackaday.io/project/192557-dodecargb
 - Homepage: (Jeremy Seitz): https://somebox.com/projects
 - Firmware and build instructions: https://github.com/somebox/DodecaRGB-firmware
 - Maths: https://math.stackexchange.com/questions/1320661/efficient-construction-of-a-dodecahedron


![DodecaRGB-toss](https://github.com/somebox/dodeca-rgb-simulator/assets/7750/a48687d6-057b-425c-9e13-a75692df122e)
