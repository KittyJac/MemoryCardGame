public GameState gameState = GameState.NO_CARDS_SELECTED;
private CardList cardList;
public int cardsSelected;
private int card1Index, card2Index;
static public PImage backOfCard;
static public PImage card1, card2 ,card3 ,card4, card5, card6, card7, card8, card9, card10;

final int delay = 30; // aantal frames 
int delayCounter = 0;

void setup() {
  size(1500,850);
  frameRate(60);
  cardList = new CardList(20);
}

void draw() {
  
  //drawStartScreen();
  drawGameScreen();
  
  switch(gameState) {
     case NO_CARDS_SELECTED:
       cardsSelected = 0;
       break;
     case DELAY:
      delayCounter++;
      if(delayCounter >= delay) {
        delayCounter = 0;
        
        // KAARTEN VERWIJDEREN
        removeCardsIfEqual(cardList);
        
        gameState = GameState.NO_CARDS_SELECTED;
      }
     break;
  }
}

void mousePressed() {
  for (int i = 0; i < cardList.cards.size(); i++) {
    if (cardList.cards.get(i).mouseOverCard() && cardList.cards.get(i).status != CardStatus.FLIPPED) {
        switch(gameState) {
      case NO_CARDS_SELECTED:
        cardList.flipCurrentCard();
        gameState = GameState.ONE_CARD_SELECTED;
        cardsSelected = 1;
      break;
      case ONE_CARD_SELECTED:
        cardList.flipCurrentCard();
        gameState = GameState.TWO_CARDS_SELECTED;
        cardsSelected = 2;
        // geen break hier
      case TWO_CARDS_SELECTED:
        gameState = GameState.DELAY;
        break;
      }
    }
  }
}

private void removeCardsIfEqual(CardList list) {
    int cardIndexCounter = 0;
    for (int i = 0; i < list.cards.size(); i++) {
      if (list.cards.get(i).status == CardStatus.FLIPPED) {
        if (cardIndexCounter == 0) { card1Index = i; } else { card2Index = i; }
        cardIndexCounter++;
      }
      if (cardIndexCounter >= 2) {
        cardIndexCounter = 0;
      }
    }
    if (cardsSelected == 2) {
      compareCards(list);
    }
  }
  
private void compareCards(CardList list) {
    if (list.cards.get(card1Index).value == list.cards.get(card2Index).value) {
      list.cards.remove(card1Index);
      list.cards.remove(card2Index - 1);
    } else {
      list.cards.get(card1Index).status = CardStatus.VISIBLE;
      list.cards.get(card2Index).status = CardStatus.VISIBLE;
    }
  }

void drawStartScreen() {
  background(205);
  DiffEasy easy = new DiffEasy();
  DiffMedium medium = new DiffMedium();
  DiffHard hard = new DiffHard();
  fill(0);
  textSize(50);
  text("Memory Card Game", width/2 - textWidth("Memory Card Game")/2, 60);
  textSize(30);
  text("Select your difficulty", width/2 - textWidth("Select your difficulty")/2, 150);
  easy.drawPanel();
  rect(width/2-200, 250, 400, 500);
  rect(1000, 250, 400, 500);

  text("Medium", width/2 - 100, 450);
  text("Hard", 1140, 450);
}

void drawGameScreen() {
  background(205);
  textSize(28);
  fill(0);
  text("Memory Card Game", 10, 40);
  strokeWeight(3);
  line(0,60,300,60);
  line(300,0,300,height);
  text("Cards selected: " + cardsSelected, 10, 150);
  text("Cards left: " + cardList.cards.size(), 10, 300);
  
  cardList.drawAllCards();
}
