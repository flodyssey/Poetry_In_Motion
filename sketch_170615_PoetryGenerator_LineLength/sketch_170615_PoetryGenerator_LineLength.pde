import oscP5.*;
import rita.*;
import sound.SpeechSynthesis;
String defaultVoice = "Alex";
SpeechSynthesis speechSynthesis;
OscP5 oscP5;


RiText rts[];
RiMarkov markov;

String sentence = "";
String[] sentenceWords = {};
String poem = "";
int wordCount = 0;


void setup() {
  size(500,500);
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

void mousePressed() {  
  String[] newWord= markov.getCompletions("the");
  println(newWord);
  
 
  
  
  // if (wordCount == sentenceWords.length) {
  //  String newSentence = markov.generateSentence() + "\n";
  //  sentenceWords = split(newSentence, ' ');
  //  wordCount = 0; }
  //poem += sentenceWords[wordCount] + " ";
  //++wordCount;
  //speechSynthesis.say("Samantha", sentenceWords[wordCount]);

}