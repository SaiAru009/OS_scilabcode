clc
Q1=[],Q2=[],Q3=[];
n=input("Enter no of processes in HIGHEST PRIORITY queue");
for i=1:n
Q1(i)=struct('pid',0,'AT',0,'BT',0,'TAT',0,'WT',0,'RT',0,'CT',0);
/*SOME NOTATIONS FOR EACH PROCESS IN THE QUEUES*/
// 'pid'- Process Number/ID, 'BT'- burst time, 'WT'- waiting time
// 'TAT'- turnaround time, 'RT'- remaining time, 'CT'- Complete time.
end
r=1,time=0,tq1=5,tq2=8,flag=0,k=1,tot=0,wt=0,tat=0;
for i=1:n
Q1(i).pid=i;
Q1(i).AT=input("Enter the arrival time of process "+string(i)+":");
Q1(i).BT=input("Enter the burst time of process "+string(i)+":");
tot=tot+Q1(i).BT;
/*save INITIAL remaining time as burst time for each process*/
Q1(i).RT=Q1(i).BT;
end
tmp=struct('PID',0,'AT',0,'BT',0,'TAT',0,'WT',0,'RT',0,'CT',0);

/*The BELOW 10 Lines perform SORTING of Q1 based on Arrival time of the processes*/
for i=1:n
  for j=i+1:n
    if Q1(i).AT > Q1(j).AT then
       tmp=Q1(i);
Q1(i)=Q1(j);
Q1(j)=tmp;
    end
  end
end

//Initial Total time assigned as least arrival time of the queued processes.
time=Q1(1).AT;
mprintf("\tProcess in first queue following RR with Time Quantum=5");
mprintf("\nProcess\t\tRT\t\tWT\t\tTAT\t\t");
for i=1:n
if Q1(i).RT<=tq1 then
time=time+Q1(i).RT;
Q1(i).RT=0;
/*Calculating Waiting Time of the ith process in queue Q1*/
Q1(i).WT=time-Q1(i).AT-Q1(i).BT;
wt=wt+Q1(i).WT;           //Calculating tot waiting time.
Q1(i).TAT=time-Q1(i).AT;
/*ith process time from arrival to execution completion*/
tat=tat+Q1(i).TAT;
mprintf("\n%d\t\t%d\t\t%d\t\t%d",Q1(i).pid,Q1(i).BT,Q1(i).WT,Q1(i).TAT);
else
/*process moves to queue 2 with qt=8*/
Q2(k)=struct('pid',0,'AT',0,'BT',0,'TAT',0,'WT',0,'RT',0,'CT',0);
Q2(k).WT=time;
time=time+tq1;
Q1(i).RT=Q1(i).RT-tq1;
Q2(k).BT=Q1(i).RT;
Q2(k).RT=Q2(k).BT;
Q2(k).pid=Q1(i).pid;
k=k+1;
flag=1;
end
end
if flag==1 then
mprintf("\n\nProcess in second queue following RR with Time Quantum=8");
mprintf("\nProcess\t\tRT\t\tWT\t\tTAT\t\t");
end
for i=1:k-1
if Q2(i).RT<=tq2 then
time=time+Q2(i).RT;
/*from arrival time of first process PLUS BT of this process*/
Q2(i).RT=0;
Q2(i).WT=time-tq1-Q2(i).BT;
wt=wt+Q2(i).WT;
Q2(i).TAT=time-Q2(i).AT;
tat=tat+Q2(i).TAT;
mprintf("\n%d\t\t%d\t\t%d\t\t%d",Q2(i).pid,Q2(i).BT,Q2(i).WT,Q2(i).TAT);
else
/*process moves to queue 3 with FCFS*/
Q3(r)=struct('pid',0,'AT',0,'BT',0,'TAT',0,'WT',0,'RT',0,'CT',0); 
Q3(r).AT=time;
time=time+tq2;
Q2(i).RT=Q2(i).RT-tq2;
Q3(r).BT=Q2(i).RT;
Q3(r).RT=Q3(r).BT;
Q3(r).pid=Q2(i).pid; r=r+1; flag=2;
end
end
if(flag==2) then
mprintf("\n\n\tProcess in third queue following FCFS");
mprintf("\nProcess\t\tRT\t\tWT\t\tTAT\t\t");
end
for i=1:r-1
if i==1 then
Q3(i).CT=Q3(i).BT+time-tq1-tq2;
else
Q3(i).CT=Q3(i-1).CT+Q3(i).BT;
end
end
for i=1:r-1
Q3(i).TAT=Q3(i).CT;
tat=tat+Q3(i).TAT;
Q3(i).WT=Q3(i).TAT-Q3(i).BT;
wt=wt+Q3(i).WT;
mprintf("\n%d\t\t%d\t\t%d\t\t%d\t\t",Q3(i).pid,Q3(i).BT,Q3(i).WT,Q3(i).TAT);
end

mprintf("\nAVG Execution time: %f",tot/n);
mprintf("\nAVG Waiting time: %f",wt/n);
mprintf("\nAVG Turnaround time: %f",tat/n);
