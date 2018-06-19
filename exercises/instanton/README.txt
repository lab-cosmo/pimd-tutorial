

Inside the 'input' folder you can find all the required files to perform an instanton rate calculation with i-PI
Inside the 'solution' folder you can find all the expected results. 


Here I show how to do the simulation with the provided inputs and how to use the post proc. scripts.
Not all features are shown in this example
 

Work flow:

(Adjust your python path and compile the driver first)

A TS optimization
A.1 Go to the folder input/TS
A.2 Run  i-pi typing: i-pi input.xml  &
A.3 Run the driver typing: i-pi-driver -m ch4hcbe -u

The simulation takes 12 steps.
TS  geometry: INSTANTON_FINAL_12.xyz
Hessian at transition state: INSTANTON_FINAL.hess_12

B Reactant  minimization
B.1 Go to the folder input/reactant/minimization
B.2 Run  i-pi typing: i-pi input.xml  &
B.3 Run the driver typing: i-pi-driver -m ch4hcbe -u

The simulation takes 31 steps.
Final geometry: last frame in min.xc.xyz


C Calculation the Reactant hessian
C.1 Go to the folder input/reactant/phononos
C.2 Copy the optimized geometry obtained in B and named it init.xyz
C.3 Run  i-pi typing: i-pi input.xml  &
C.4 Run the driver typing: i-pi-driver -m ch4hcbe -u

Hessian file: phonons.hess


D. First Instanton calculation
D.1 Go to the folder input/instanton/40
D.2 Copy the optimized transition state geometry obtained in A and name it init.xyz
D.3 Copy the transition state hessian obtained in A and name it hessian.dat
D.4 Run i-pi typing: i-pi input.xml  &
D.5 Run the 4 instances of driver typing:
 i-pi-driver -m ch4hcbe -u &
 i-pi-driver -m ch4hcbe -u &
 i-pi-driver -m ch4hcbe -u &
 i-pi-driver -m ch4hcbe -u &

The program first generate the initial instanton guess and then performs a optimization which takes 8 steps
Finally a hessian is also computed
instanton geometry: INSTANTON_FINAL_7.xyz
Last physical Hessian (it does not contain the spring terms) : INSTANTON_FINAL.hess_7
(In this case it is the exact hessian but could also be an approximation to it)

E Second and sucesive instanton calculations
E.1 Go to folder input/instanton/80
E.2 Copy the optimized instanton geometry obtained in D and name it init0
E.3 Copy the last hessian obtained in D and name it hess0 
E.4 Interpolate the instanton and the hessian to 80 beads by typing:
' python (ipi-path)/tools/py/Instanton_interpolation.py -m -xyz init0 -hess hess0 -n 80'
E.5 Rename the new hessian and instanton geometry to hessian.dat and init.xyz respectively
E.6 Copy the 'input.xml' file from input/instanton/40 
E.7 Change the number of beads from 40 to 80 (input.xml) 
E.8 Change the hessian shape from (18,18) to (18,1440) (input.xml) 
E.9 Run i-pi typing: i-pi input.xml  &
E.10  Run the 4 instances of driver typing:
 i-pi-driver -m ch4hcbe -u &
 i-pi-driver -m ch4hcbe -u &
 i-pi-driver -m ch4hcbe -u &
 i-pi-driver -m ch4hcbe -u &

The program performs a optimization which takes 2  steps
Finally a hessian is computed
instanton geometry: INSTANTON_FINAL_2.xyz
Last physical Hessian (it does not contain the spring terms) : INSTANTON_FINAL.hess_2 

F Post proc.
F.1. CH4 partition function
F.1.1 Go the input/reactant/phonons folder
F.1.2 type ' python (ipi-path)/tools/py/Instanton_postproc.py RESTART -c reactant -t 300 -n 80 -f 5 ' 
(computes the ring polymer parittion function for CH4 witn n=80)
(check data.out file in the corresponding inside 'solution')

F.2. TS  partition function
F.2.1 Go the input/TS folder
F.2.2 type python '~/Codes/i-pi/ipi-dev/tools/py/Instanton_postproc.py RESTART -c TS -t 300 -n 80'
(computes the ring polymer parittion function for TS witn n=80)
(check data.out file in the corresponding inside 'solution')

F.3. instanton  partition function ,BN and action
F.3.1 Go the input/instanton/80
F.3.2 python ~/Codes/i-pi/ipi-dev/tools/py/Instanton_postproc.py RESTART -c instanton -t 300
(check data.out file in the corresponding inside 'solution')

DONE
