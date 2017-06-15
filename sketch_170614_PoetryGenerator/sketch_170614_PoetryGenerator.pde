import oscP5.*;

import rita.*;
import sound.SpeechSynthesis;

String defaultVoice = "Alex";
SpeechSynthesis speechSynthesis;
OscP5 oscP5;


//int MAX_LINE_LENGTH = 140;
//String data = "http://rednoise.org/rita/data/";
//String chars = "q,w,e,r,t,y,u,i,o,p,a,s,d,f,g,h,j,k,l,z,x,c,v,b,n,m,Q,W,E,R,T,Y,U,I,O,P,A,S,D,F,G,H,J,K,L,Z,X,C,V,B,N,M,;,.,,:,~,`,"; //chars to mess the tweet up with
//static int charsLen = 60; //length of chars string

RiText rts[];
RiMarkov markov;

String prevUnmodifiedPoem = "";
String prevModPoem = "";

String sentence = "";
String[] sentenceWords = {};

String poem = "";

boolean generated;
int wordCount = 0;

void setup() {
  fullScreen();
  oscP5 = new OscP5(this, 12000); //listen for OSC messages on port 12000 (Wekinator default)

  markov = new RiMarkov(this, 3);  //model that tokenizes based on whitespace characters

  //markov.loadFrom("beowulf.txt");
  //markov.loadFrom("keats.txt");
  //markov.loadFrom("dante.txt");
  //markov.loadFrom("milton.txt");
  //markov.loadFrom("shakespeare.txt");
  markov.loadFrom("dickinson.txt");
  //markov.loadFrom("seuss.txt");

  speechSynthesis = new SpeechSynthesis();
  sentence = markov.generateSentence() + "\n";
  sentenceWords = split(sentence, ' ');
  wordCount = 0;
}

void draw() {
  background(#E3DFC7);
  fill(0, 0, 0);
  text("Dance and I'll write you a poem.", 20, 45);
  text(sentenceWords[wordCount], 20, 100);
  textSize(60);
  textLeading(60);
}

void mousePressed() {    
  if (wordCount == sentenceWords.length - 1) {
    String newSentence = markov.generateSentence() + "\n";
    sentenceWords = split(newSentence, ' ');
    wordCount = 0;
  }
  poem += sentenceWords[wordCount] + " ";
  speechSynthesis.say("Samantha", sentenceWords[wordCount]);
  
  if (wordCount < sentenceWords.length - 1) {
    ++wordCount;
  }
}


//void serialEvent(Serial arduino) {
//  String inString = arduino.readStringUntil('\n');
//  int arduinoMsg = 0;
//  if (inString != null) {
//    // trim off any whitespace:
//    inString = trim(inString);
//    arduinoMsg = int(inString);
//    println(arduinoMsg);

//    String poem = markov.generateSentence();
//    prevUnmodifiedPoem = poem;
//    String msg = randomize(poem, arduinoMsg);
//    prevModPoem = msg;
//    postMsg(msg);
//    delay(12000);
//  }
//}

//String randomize(String poem, int emiVal) {
//  String[] list = split(poem, " ");
//  //println(list);
//  int changes = 0; //keeps track of how many changes we've made to the poem
//  while (changes < emiVal) { //number of changes we'll make is based on EMI
//    int change = int(random(3)); //determines which change we'll make this pass

//    if (change==0) {
//      list = reverse(list);
//    }

//    if (change==1) {
//      list = sort(list);
//    }
//    if (change==2) {
//      list = shorten(list);
//    }
//    if (change==4) {
//      list = appendRandom(list);
//    }

//    if (change==3) {
//      list = spliceRandom(list);
//    }

//    changes ++;
//  }
//  poem = join(list, " ");
//  return poem;
//}

//String[] appendRandom(String[] list) {
//  int randomLen = int(random(1, 7)); //random length of string to append
//  int randomInd = int(random(1, 60)); //random index
//  // String[] charsList = chars.split(",");
//  String toAppend = chars.substring(randomInd, randomInd+randomLen);
//  String[] list2 = append(list, toAppend);
//  return list2;
//}

//String[] spliceRandom(String[] list) {
//  int randomLen = int(random(1, 7)); //random length of string to splice
//  int randomInd = int(random(1, 60)); //random index
//  int index = int(random(0, 5)); //6 words is minimum length of sentence; this index is where we'll splice in
//  String toSplice = chars.substring(randomInd, randomInd+randomLen);
//  String[] list2 = splice(list, toSplice, index);
//  return list2;
//}