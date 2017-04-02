//Este código fué realizado por Carlos Lino Rengifo Renteria
//Todos los derechos reservados.


String[] lines;
PGraphics pg;
float y,yant;
int ii,id;
float [] datos = new float[320];
float [] RR = new float[320];
int estado;
float mayor;
int derivada;
int RRi; //para llenar el estado del pico;
int index;
int start;

float umbral;

void setup() {
  lines = loadStrings("ecg.txt");
  size(320, 240);
  pg = createGraphics(320, 240);
  //frameRate(1000);
  ii=-1; //variable para recorrer el txt
  id=0; //variable para muestreo
  RRi=0;  
  umbral=18000;
  derivada=0;
  index=0;
  for(int i=1;i<width;i++){
    datos[i]=-10000;
  }
  estado=0;
  start=0;

}

void draw() {
  pg.beginDraw();
  
   if(start==0 && estado==0){
     fondo();
     start=1;
   }
   if(estado==1)
     fondo();
  filling();
  plotting();
  pg.endDraw();
  image(pg, 0, 0);  
}

void filling(){
  control();
  if(estado == 0){
    datos[ii]=leerDato();        
  }
  else{
    y=leerDato();
   
  }
}
   
void plotting(){
  
  if(estado==0){
    for(int i=0;i<width;i++){
      if(i==0 && datos[i]!=-10000){
        
        pg.line(i,datos[i],i,datos[i]);
        yant=datos[i];
      }
      if(i!=0 && datos[i]!=-10000){
        
        if(detectarPico(yant,datos[i])==1 && i-index>10){
          pg.stroke(255,0,0);
          pg.strokeWeight(10);
          pg.point(i-1,datos[i-1]);
          pg.strokeWeight(0);
          pg.stroke(0);
          index=i;
        }
        pg.line(i-1,yant,i,datos[i]);
        yant=datos[i];
       }
    }
  }
  
  if(estado==1){
    desplaza();
    for(int i=0;i<width;i++){
      if(i==0){
        pg.line(i,datos[i],i,datos[i]);
        yant=datos[i];
      }
      else{
        if(detectarPico(yant,datos[i])==1 && i-index>10){
          pg.stroke(255,0,0); 
          pg.strokeWeight(10);
          pg.point(i-1,datos[i-1]);
          pg.strokeWeight(1);
          pg.stroke(0);
          index=i;
        }
        pg.line(i-1,yant,i,datos[i]);
        yant=datos[i];
      }
    }
  }
  
}

void control(){
  ii++;
  id=id+2;
  if(ii==width){
     estado=1;     
  }
 
}




void desplaza(){
  index=0;
  for(int i=1;i<width;i++){
    datos[i-1]=datos[i];
  }
   datos[319]=y;
}

void fondo(){
  int delta, dx,dy;
  
  dy=0;
  dx=0;
  
  delta = (int) (height-20)/24;
  pg.background(255);
  
  
  for(int i=10;i<height-10;i=i+delta){
    dx++;
    if(dx % 6 ==0){
      pg.stroke(240,121,99);
    }
    else{
      pg.stroke(240,186,176);
    }
    pg.line(10,i,width-10,i);
    
  }
  for(int i=10;i<width-10;i=i+delta){
       dy++;
    if(dy % 6 ==0){
      pg.stroke(240,121,99);
    }
    else{
      pg.stroke(240,186,176);
    }
    pg.line(i,10,i,height-10);
  }
  pg.stroke(0);
  pg.strokeWeight(1);
}


int detectarPico(float yant,float y){
  yant=height-yant;
  y = height-y;
  yant=yant*yant;
  y=y*y;
  
  
    //1 para un pico R
    //0 no es pico
    
    if(yant > umbral && derivada == 0 ){ //corroborando que estemos subiendo para empezar el algoritmo
      if(y-yant>=0){
        derivada = 1;
        mayor=-10000;
      }
    }
    
    
    if(yant > umbral && derivada==1){//buscando un pico
      
      if(y-yant>=0){ //voy subiendo
        if(yant > mayor){
          mayor=yant;
          
          
          return 0;
        }
      }
      if(y-yant<0){//acabe de bajar              
        return 1;
      }
    }
    
      
   return 0;
}

float leerDato(){
   if(id>5900)
     id=0;
   return (120-(Float.parseFloat(lines[id]))*40);    

}