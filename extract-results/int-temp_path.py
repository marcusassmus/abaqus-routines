from abaqus import *
from abaqusConstants import *
from viewerModules import *
from odbAccess import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
import odb


x_loc_int_temp=1.02362e+003 #from abaqus gui

my_odb = session.openOdb(name='C:/assmus/projekte/siemens/welle_rotor_md/basic_elastic/axle_md-temp_dist-int_temp.odb')

session.viewports['Viewport: 1'].setValues(displayedObject=my_odb)

all_nodes=my_odb.rootAssembly.instances['AXLE_MD-1'].nodes[:]

IntPathSet=[]
for i1 in all_nodes:
    if (x_loc_int_temp-((x_loc_int_temp)/1000.0)) < i1.coordinates[1] < (x_loc_int_temp+((x_loc_int_temp)/1000.0)):
        IntPathSet.append(i1)

#seperate the frames
n_frame=my_odb.steps['Loading'].frames

i2=xrange(len(n_frame)) #loop over all frames
for i1 in i2:
    #getting the step time of the frame
    frame_info=n_frame[i1].description
    frame_time=float(frame_info[frame_info.index('=')+1:].strip())
    output_file=file('C:/assmus/projekte/siemens/welle_rotor_md/basic_elastic/temperature_txt_files/frame_%s.txt' % (i1), 'w')
    output_file.write(' Nodelabel\t Temperature[°C]\t x-Coord[mm]\t y-Coord[mm]\t Step Time\n')
    for i3 in IntPathSet:
        nodal_temp=n_frame[i1].fieldOutputs['NT11'].getSubset(region=i3).values
        output_file.write(' \t%i \t\t\t%.2f\t\t\t\t%.2f\t\t\t%.2f\t\t\t%.2f\n' % (i3.label, nodal_temp[0].data, i3.coordinates[0], i3.coordinates[1], frame_time))
    
    output_file.close()

#EOF