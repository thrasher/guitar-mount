#!/usr/bin/python
import subprocess
import math 

# creates the points used in the polygon for the clip
# part is 10mm diameter which can be scaled to any size
# this was an experiment in getting arbitrary arrays of points used in a polygon
def polygon():
	radius = 10 # 10mm diameter default can be scaled in scad file
	thickness = .001 # scad deals with polygons, not lines, so a non-zero thickness is needed
	len = 270 + 1 # rotational degrees - note extra degree is added to close the part
	dec = 3 # decimal points
	points = [[0 for x in range(2)] for y in range(2 * len)] 

	# outer arc of polygon
	for i in range(len):
		x = round(radius * math.cos(math.radians(i)), dec)
		y = round(radius * math.sin(math.radians(i)), dec)

		points[i] = [x, y]

	# inner arc of polygon
	for i in range(len):
		ang = len - i - 1
		x = round((radius - thickness) * math.cos(math.radians(ang)), dec)
		y = round((radius - thickness) * math.sin(math.radians(ang)), dec)

		points[i+len] = [x, y]

	# write them out to spot check
	#print(points)

	# write to file imported by scad
	file = open("polygon.scad","w")
	file.write('// generated from render.py\n')
	file.write('POLYGON_RADIUS = 10;\n')
	file.write("points = ")
	file.write("{}".format(points))
	file.write(";")
	file.close() 

# render the stl
def render():
	#subprocess.check_output(['ls','-l']) #all that is technically needed...
	print subprocess.check_output(['openscad','-Dmode=1','mount.scad','-o','ukulele-clip.stl'])
	print subprocess.check_output(['openscad','-Dmode=2','mount.scad','-o','ukulele-wall.stl'])

def main():
	polygon()
	render()

main()