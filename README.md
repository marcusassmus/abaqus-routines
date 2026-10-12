This is a personal collection of specific routines for performing various computations in mechanics using the [ABAQUS FEA software](https://www.3ds.com/products/simulia/abaqus), with code written in FORTRAN and Python. They cover aspects of structural mechanics, mechanics of materials, and micromechanics.

* [GitHub Repo](https://github.com/marcusassmus/abaqus-routines)
* [Help](http://130.149.89.49:2080/v2016/pdf_books/SCRIPT_USER.pdf)

**Contents**

<!-- tree:start -->
├── [README.md](README.md)  
├── [extract-results](extract-results)  
│   ├── [int-temp_path.py](extract-results/int-temp_path.py)  
│   └── [srecover.py](extract-results/srecover.py)  
├── [input-generator](input-generator)  
│   ├── [inp_end.txt](input-generator/inp_end.txt)  
│   ├── [inp_middle.txt](input-generator/inp_middle.txt)  
│   ├── [inp_middle2.txt](input-generator/inp_middle2.txt)  
│   ├── [inp_middle3.txt](input-generator/inp_middle3.txt)  
│   ├── [inp_preamble.txt](input-generator/inp_preamble.txt)  
│   ├── [inp_preamble2.txt](input-generator/inp_preamble2.txt)  
│   ├── [lwt8_inp_generator.m](input-generator/lwt8_inp_generator.m)  
│   ├── [lwt8_inp_generator_elements.m](input-generator/lwt8_inp_generator_elements.m)  
│   └── [lwt8_inp_generator_nodes_coor.m](input-generator/lwt8_inp_generator_nodes_coor.m)  
├── [linking](linking)  
│   └── [20210614_installing-abq2020.txt](linking/20210614_installing-abq2020.txt)  
├── [multiscale](multiscale)  
│   └── [projection.for](multiscale/projection.for)  
├── [parameter-study](parameter-study)  
│   ├── [abaqus_script.bat](parameter-study/abaqus_script.bat)  
│   ├── [parametric-nu.psf](parameter-study/parametric-nu.psf)  
│   └── [parametric.psf](parameter-study/parametric.psf)  
├── [umat](umat)  
│   ├── [elastic.for](umat/elastic.for)  
│   └── [von-mises-plast.for](umat/von-mises-plast.for)  
└── [volume-averaging](volume-averaging)  
    └── [volumeAveraging.py](volume-averaging/volumeAveraging.py)  
<!-- tree:end -->
