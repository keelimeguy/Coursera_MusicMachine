//The MIT License (MIT) - See Licence.txt for details

//Copyright (c) 2013 Mick Grierson, Matthew Yee-King, Marco Gillies


Maxim maxim;
AudioPlayer sample1;
AudioPlayer sample2;
AudioPlayer sample3;
AudioPlayer sample4;
WavetableSynth synth1;
WavetableSynth synth2;

boolean[] track1;
boolean[] track2;
boolean[] track3;
boolean[] track4;

int[] notes = {
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0
};
int[] notes2 = {
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0
};

int transpose = 0;
int transpose2 = 24;
float fc, res, attack, release, filterAttack;
float fc2, res2, attack2, release2, filterAttack2;

int playhead;

int numBeats;
int currentBeat;
int buttonWidth;
int buttonHeight;

String cur1 = "";
String cur2 = "";
String cur3 = "";
String cur4 = "";

int numInstruments = 6;

PImage backgroundImage;
Slider dt, dg, a, r, f, q, fa, o, dt2, dg2, a2, r2, f2, q2, fa2, o2;
MultiSlider seq, seq2;

ComboBox instr1, instr2, instr3, instr4;

int widthConst = 1024;
int heightConst = 768;
int comboWidth = 100;

void setup() {
 size(1124, 768);
 numBeats = 16;
 currentBeat = 0;
 buttonWidth = widthConst / numBeats;
 buttonHeight = heightConst / 12;

 maxim = new Maxim(this);

 synth1 = maxim.createWavetableSynth(514);
 synth1.play();
 synth1.volume(0.25);
 synth2 = maxim.createWavetableSynth(514);
 synth2.play();
 synth2.volume(0.25);

 // set up the sequences
 track1 = new boolean[numBeats];
 track2 = new boolean[numBeats];
 track3 = new boolean[numBeats];
 track4 = new boolean[numBeats];
 backgroundImage = loadImage("brushedm.jpg");
 frameRate(60);

 instr1 = new ComboBox(numInstruments, numBeats * buttonWidth, 500 + (0 * buttonHeight), comboWidth, 10);
 instr1.set(0, ": instr1");
 instr1.open(1);
 for (int i = 1; i < numInstruments; i++)
  instr1.set(i, "instr" + i);

 instr2 = new ComboBox(numInstruments, numBeats * buttonWidth, 500 + (1 * buttonHeight), comboWidth, 10);
 instr2.set(0, ": instr2");
 instr1.open(2);
 for (int i = 1; i < numInstruments; i++)
  instr2.set(i, "instr" + i);

 instr3 = new ComboBox(numInstruments, numBeats * buttonWidth, 500 + (2 * buttonHeight), comboWidth, 10);
 instr3.set(0, ": instr3");
 instr1.open(3);
 for (int i = 1; i < numInstruments; i++)
  instr3.set(i, "instr" + i);

 instr4 = new ComboBox(numInstruments, numBeats * buttonWidth, 500 + (3 * buttonHeight), comboWidth, 10);
 instr4.set(0, ": instr4");
 instr1.open(4);
 for (int i = 1; i < numInstruments; i++)
  instr4.set(i, "instr" + i);

 dt = new Slider("delay time", 1, 0, 100, 110, 10, 200, 20, HORIZONTAL);
 dg = new Slider("delay amnt", 1, 0, 100, 110, 30, 200, 20, HORIZONTAL);
 a = new Slider("attack", 1, 0, 100, 110, 50, 200, 20, HORIZONTAL);
 r = new Slider("release", 20, 0, 100, 110, 70, 200, 20, HORIZONTAL);
 f = new Slider("filter", 20, 0, 100, 110, 90, 200, 20, HORIZONTAL);
 q = new Slider("res", 20, 0, 100, 110, 110, 200, 20, HORIZONTAL);
 fa = new Slider("filterAmp", 20, 0, 100, 110, 130, 200, 20, HORIZONTAL);
 o = new Slider("transpose", 0, 1, 80, 110, 150, 200, 20, HORIZONTAL);
 // name,s min, max, pos.x, pos.y, width, height
 seq = new MultiSlider(notes.length, 0, 256, 0, 300, widthConst / 18 / 2, 150, UPWARDS);
 // name, value, min, max, pos.x, pos.y, width, height

 dt2 = new Slider("delay time", 1, 0, 100, 620, 10, 200, 20, HORIZONTAL);
 dg2 = new Slider("delay amnt", 1, 0, 100, 620, 30, 200, 20, HORIZONTAL);
 a2 = new Slider("attack", 1, 0, 100, 620, 50, 200, 20, HORIZONTAL);
 r2 = new Slider("release", 20, 0, 100, 620, 70, 200, 20, HORIZONTAL);
 f2 = new Slider("filter", 20, 0, 100, 620, 90, 200, 20, HORIZONTAL);
 q2 = new Slider("res", 20, 0, 100, 620, 110, 200, 20, HORIZONTAL);
 fa2 = new Slider("filterAmp", 20, 0, 100, 620, 130, 200, 20, HORIZONTAL);
 o2 = new Slider("transpose", 0, 1, 80, 620, 150, 200, 20, HORIZONTAL);
 // name,s min, max, pos.x, pos.y, width, height
 seq2 = new MultiSlider(notes2.length, 0, 256, widthConst / 2, 300, widthConst / 18 / 2, 150, UPWARDS);
}

void draw() {
 if (!cur1.equals(instr1.get(0).substring(2))) {
  sample1 = maxim.loadFile(instr1.get(0).substring(2) + ".wav");
  sample1.volume(0.5);
  sample1.setLooping(false);
  cur1 = instr1.get(0).substring(2);
 }
 if (!cur2.equals(instr2.get(0).substring(2))) {
  sample2 = maxim.loadFile(instr2.get(0).substring(2) + ".wav");
  sample2.setLooping(false);
  sample2.volume(1);
  cur2 = instr2.get(0).substring(2);
 }
 if (!cur3.equals(instr3.get(0).substring(2))) {
  sample3 = maxim.loadFile(instr3.get(0).substring(2) + ".wav");
  sample3.volume(0.5);
  sample3.setLooping(false);
  cur3 = instr3.get(0).substring(2);
 }
 if (!cur4.equals(instr4.get(0).substring(2))) {
  sample4 = maxim.loadFile(instr4.get(0).substring(2) + ".wav");
  sample4.setLooping(false);
  cur4 = instr4.get(0).substring(2);
}

 image(backgroundImage, 0, 0);
 //background(0);

 stroke(255);
 for (int i = 0; i < 5; i++)
  line(0, 500 + (i * heightConst / 12), widthConst, 500 + (i * heightConst / 12));
 for (int i = 0; i < numBeats + 1; i++)
  line(i * widthConst / numBeats, 500, i * widthConst / numBeats, 500 + (4 * heightConst / 12));


 // draw a moving square showing where the sequence is 
 fill(0, 0, 200, 120);
 rect(currentBeat * buttonWidth, 500, buttonWidth, heightConst);

 for (int i = 0; i < numBeats; i++) {
  noStroke();
  fill(200, 0, 0);

  if (track1[i])
   rect(i * buttonWidth, 500 + (0 * buttonHeight), buttonWidth, buttonHeight);
  if (track2[i])
   rect(i * buttonWidth, 500 + (1 * buttonHeight), buttonWidth, buttonHeight);
  if (track3[i])
   rect(i * buttonWidth, 500 + (2 * buttonHeight), buttonWidth, buttonHeight);
  if (track4[i])
   rect(i * buttonWidth, 500 + (3 * buttonHeight), buttonWidth, buttonHeight);
 }

 playhead++;
 //if (frameCount%4==0) {// 4 frames have passed check if we need to play a beat
 if (playhead % 4 == 0) {
  if (track1[currentBeat]) // track1 wants to play on this beat
  {
   sample1.cue(0);
   sample1.play();
  }
  if (track2[currentBeat]) {
   sample2.cue(0);
   sample2.play();
  }
  if (track3[currentBeat]) {
   sample3.cue(0);
   sample3.play();
  }
  if (track4[currentBeat]) {
   sample4.cue(0);
   sample4.play();
  }

  // now the synths
  //synth1.ramp(0.5, attack);
  synth1.setFrequency(mtof[notes[playhead / 4 % 16] + 30]);
  //waveform.filterRamp((fc/100)*(filterAttack*0.2), attack+release); 

  //synth2.ramp(0.5, attack2);
  synth2.setFrequency(mtof[notes2[playhead / 4 % 16] + 30]);
  //waveform2.filterRamp((fc2/100)*(filterAttack2*0.2), attack2+release2);


  // move to the next beat ready for next time
  currentBeat++;
  if (currentBeat >= numBeats)
   currentBeat = 0;
 }


 if (mousePressed) {
  dt.mouseDragged();
  dg.mouseDragged();
  a.mouseDragged();
  r.mouseDragged();
  f.mouseDragged();
  q.mouseDragged();
  fa.mouseDragged();
  o.mouseDragged();
  seq.mouseDragged();

  dt2.mouseDragged();
  dg2.mouseDragged();
  a2.mouseDragged();
  r2.mouseDragged();
  f2.mouseDragged();
  q2.mouseDragged();
  fa2.mouseDragged();
  o2.mouseDragged();
  seq2.mouseDragged();

 }

 // process gui events

 if (f.get() != 0) {
  fc = f.get() * 100;
  synth1.setFilter(fc, res);
 }
 if (dt.get() != 0) {
  synth1.setDelayTime((float) dt.get() / 50);
 }
 if (dg.get() != 0) {
  //waveform.setDelayAmount((int)dg.get()/100);
 }
 if (q.get() != 0) {
  res = q.get() / 50;
  synth1.setFilter(fc, res);
 }
 if (a.get() != 0) {
  attack = a.get() * 10;
 }
 if (r.get() != 0) {
  release = r.get() * 10;
 }
 if (fa.get() != 0) {
  filterAttack = fa.get() * 10;
 }
 if (o.get() != 0) {
  transpose = (int) Math.floor(o.get());
 }

 // synth 2:
 if (f2.get() != 0) {
  fc2 = f2.get() * 100;
  synth2.setFilter(fc2, res2);
 }
 if (dt2.get() != 0) {
  synth2.setDelayTime((float) dt2.get() / 50);
 }

 if (dg2.get() != 0) {
  //synth2.setDelayAmount((int)dg2.get()/100);
 }

 if (q2.get() != 0) {
  res2 = q2.get() / 50;
  synth2.setFilter(fc2, res2);
 }

 if (a2.get() != 0) {
  attack2 = a2.get() * 10;
 }

 if (r2.get() != 0) {
  release2 = r2.get() * 10;
 }

 if (fa2.get() != 0) {
  filterAttack2 = fa2.get() * 10;
 }

 if (o2.get() != 0) {
  transpose2 = (int) Math.floor(o2.get());
 }

 // draw gui widgets


 dt.display();
 dg.display();
 a.display();
 r.display();
 f.display();
 q.display();
 fa.display();
 o.display();
 seq.display();


 dt2.display();
 dg2.display();
 a2.display();
 r2.display();
 f2.display();
 q2.display();
 fa2.display();
 o2.display();
 seq2.display();

 instr1.display();
 instr2.display();
 instr3.display();
 instr4.display();
}

void mousePressed() {

 dt.mousePressed();
 dg.mousePressed();
 a.mousePressed();
 r.mousePressed();
 f.mousePressed();
 q.mousePressed();
 o.mousePressed();
 fa.mousePressed();
 seq.mousePressed();

 dt2.mousePressed();
 dg2.mousePressed();
 a2.mousePressed();
 r2.mousePressed();
 f2.mousePressed();
 q2.mousePressed();
 fa2.mousePressed();
 o2.mousePressed();
 seq2.mousePressed();

 instr1.mousePressed();
 instr2.mousePressed();
 instr3.mousePressed();
 instr4.mousePressed();

 int index = (int) Math.floor(mouseX * numBeats / widthConst);
 int track = (int) Math.floor((mouseY - 500) * (12 / (float) heightConst));

 if (index < track1.length && track == 0)
  track1[index] = !track1[index];
 if (index < track2.length && track == 1)
  track2[index] = !track2[index];
 if (index < track3.length && track == 2)
  track3[index] = !track3[index];
 if (index < track4.length && track == 3)
  track4[index] = !track4[index];
}

void mouseReleased() {
 for (int i = 0; i < notes.length; i++) {

  notes[i] = (int)(Math.floor((seq.get(i) / 256) * 12 + transpose));
  notes2[i] = (int)(Math.floor((seq2.get(i) / 256) * 12 + transpose2));
 }

 instr1.mouseReleased();
 instr2.mouseReleased();
 instr3.mouseReleased();
 instr4.mouseReleased();
}