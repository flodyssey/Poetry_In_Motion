import oscP5.*;
import rita.*;
import sound.SpeechSynthesis;
String defaultVoice = "Alex";
SpeechSynthesis speechSynthesis;
OscP5 oscP5;

float regressionValue; 


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
  markov.loadFrom("shakespeare.txt");
  //markov.loadFrom("dickinson.txt");
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
  text(poem, 20, 150, width, height); // Display full text 
  textSize(50);
  textLeading(60);
  //text(sentenceWords[wordCount], width/2, height/2); // Display single word
  //textSize(200);
  //textAlign(CENTER, CENTER);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    regressionValue = theOscMessage.get(0).floatValue();
  }

  if (regressionValue > 0.5) {
    if (wordCount == sentenceWords.length) {
      String newSentence = markov.generateSentence() + "\n";
      sentenceWords = split(newSentence, ' ');
      wordCount = 0;
    }
    poem += sentenceWords[wordCount] + " ";
    ++wordCount;
    speechSynthesis.say("Samantha", sentenceWords[wordCount]);
  }
}






//void mousePressed() {  
//  if (wordCount == sentenceWords.length) {
//    String newSentence = markov.generateSentence() + "\n";
//    sentenceWords = split(newSentence, ' ');
//    wordCount = 0;
//  }
//  poem += sentenceWords[wordCount] + " ";
//  ++wordCount;
//  speechSynthesis.say("Samantha", sentenceWords[wordCount]);
//}




//void oscEvent(OscMessage theOscMessage) {
//  if (theOscMessage.checkAddrPattern("/output_1")==true) {
//    println("output_1");
//    if (wordCount == sentenceWords.length) {
//      String newSentence = markov.generateSentence() + "\n";
//      sentenceWords = split(newSentence, ' ');
//      wordCount = 0;
//    }
//    poem += sentenceWords[wordCount] + " ";
//    speechSynthesis.say("Daniel", sentenceWords[wordCount]);
//    ++wordCount;
//    speechSynthesis.say("Daniel", sentenceWords[wordCount]);
//  } else if (theOscMessage.checkAddrPattern("/output_2")==true) {
//    println("output_2");
//    if (wordCount == sentenceWords.length) {
//      String newSentence = markov.generateSentence() + "\n";
//      sentenceWords = split(newSentence, ' ');
//      wordCount = 0;
//    }
//    poem += sentenceWords[wordCount] + " ";
//    speechSynthesis.say("Daniel", sentenceWords[wordCount]);
//    ++wordCount;
//  } else if (theOscMessage.checkAddrPattern("/output_3") == true) {
//    println("output_3");
//    if (wordCount == sentenceWords.length) {
//      String newSentence = markov.generateSentence() + "\n";
//      sentenceWords = split(newSentence, ' ');
//      wordCount = 0;
//    }
//    poem += sentenceWords[wordCount] + " ";
//    speechSynthesis.say("Daniel", sentenceWords[wordCount]);
//    ++wordCount;
//  } else if (theOscMessage.checkAddrPattern("/output_4") == true) {
//    println("output_4");
//    if (wordCount == sentenceWords.length) {
//      String newSentence = markov.generateSentence() + "\n";
//      sentenceWords = split(newSentence, ' ');
//      wordCount = 0;
//    }
//    poem += sentenceWords[wordCount] + " ";
//    speechSynthesis.say("Daniel", sentenceWords[wordCount]);
//    ++wordCount;
//  } else if (theOscMessage.checkAddrPattern("/output_5") == true) {
//    println("output_5");
//    if (wordCount == sentenceWords.length) {
//      String newSentence = markov.generateSentence() + "\n";
//      sentenceWords = split(newSentence, ' ');
//      wordCount = 0;
//    }
//    poem += sentenceWords[wordCount] + " ";
//    speechSynthesis.say("Daniel", sentenceWords[wordCount]);
//    ++wordCount;
//  } else {
//    println("Unknown OSC message received");
//  }
//}