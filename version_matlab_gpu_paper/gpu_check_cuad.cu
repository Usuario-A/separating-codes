__global__ void gpu_check_cuad(const int *Codigo,
                                 const int *quadr,
                                 int m,
                                 int n,
                                 int nquad,
                                 int * es_sep)
{
int tid=threadIdx.x+blockDim.x*blockIdx.x;
int i1, i2, i3, i4,j, v1, v2, v3, v4, iaux1;
while(tid<nquad)
   {
    iaux1=0;
    i1=quadr[tid];
    i2=quadr[tid+nquad];
	i3=quadr[tid+2*nquad];
    i4=quadr[tid+3*nquad];
	   for(j=0;j<n;j++) 
	     {v1=Codigo[i1+m*j];
		  v2=Codigo[i2+m*j];
		  v3=Codigo[i3+m*j];
          v4=Codigo[i4+m*j];
        
		  if ((v1==v2)&&(v3==v4)&&(v1!=v3))
		      iaux1=1;
		  
          }
        es_sep[tid]=iaux1;
        tid+=blockDim.x*gridDim.x;		  
       }

}