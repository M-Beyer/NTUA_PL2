//
//  Exercise 9: Scripting languages
//  Part 1: Server side scripting
//  Programming Languages 2
//  Michael Beyer
//

var pal = require('./palindromeCheck')

var questions = [ 'baaab',
                  'aaaaa',
                  'abbab',
                  'bbabba',
                  'abbaab',
                  'bbcacbcbb',
                  'bbccacac',
                  'cccaccbbba',
                  'babaacabca',
                  'ccadabbaaacbbacbccdd',
                  'rl(la1u048xyk6(72dix',
                  'qdrlnbuegst5nh95nroz',
                  '00n9jyq094ai5j3w0my2',
                  'z4em)cxykd3dcwym(cv(',
                  '8h9oh25xiafxvo(yjc04csamqat7ugq4gd3oezf1cv5h(8gwq5ppnbj9tpsnpf27zz8l0u)5pypdpirvo)xl2dqx(5xhc13eoga3',
                  '5s7pownvoyhu0(a(tgte3)0lsiqdb4863quatk9r65j0usv77v2fjmrxecul9k1o7dcnvscyesmd5ni95db6aesp46jmjcobxi8',
                  'a5s3w4l48x7gzj)vs1bmky0ds3hdmx8q3h)s0t4e391wwt)qtxdmb9yn2wfh9z1ebf28iw3qei5(rsq(l0icvh2kwmq9a25qwrx)5znnme9dl2wrjc9b048gmujchennt5d(w7zrt7m7g49vvpy4bedg00bh58837)(kwe)afo1(z2rxmyeghmx)esmkga1aqr5dspi32gnw(88dejle1o9nnp8h(1bbnzhp2)3ql2zwo(iu1n209wcqhum60tm)td81dtwt5yjiw2u84jf26whkdco7sffn7a3vl74ic2e7dm8(2vq41wfbn30ijs3w81nuy0zdxzvbshrc1(1l7edipsn68ohjuzsieio7frkr0b8lpocdvzgtdmsjfv9r1tmoal98k    145geplx7sn4jf3pje7(ybyhuzr05ya3gq77llww3(heceyaxj5jpw071vx1xydedn6b00r1jgsiy1cl9qd(nzqdeozfe(t47h2kwzx4(i9wrdajz6fmx2q1whc6h8lmgcm3wbnhz9kffamwvp1dl2sjzrsl07ioa58twyjjzrkitpqly4l6r76fqowgxdb4(wbad7zyfmfd0)oa057e4wrj2tsjf5z022ygkt9iavhtc5en1p4lw3pkh2pkhgxvm4546ravgjxnbqb57o4mipeebs252j351wr414qykidze91x098gsa1u(dpw)bfzu2cardi2b24)(fw17d6l9ky1yfypaxdm4928bx69pzorhv5b8fboz)1qd64xl4w)7b75fccbx    aqut)2c0qdzq08zdenhadxcliiwg0rqj06e3b7st)vzwxcubmz7p7bvvjggw0doxbuek9)mmc4l(2af2xab2xnbae9y1dk78l((z90kpjesggqtxym2cjuyvqiw70cpova1u2zz()v3)snicddpatuonkstodiwx44ujiqfamlxr7j(9(68ki561sfbju)oes2tcsx36wxui50rmdvfnzz'
                ];

var currentLevel = 0;


function getCurrent()
{
  if( currentLevel > questions.length - 1 )
    currentLevel = 0;

  return {
           questionNr: currentLevel + 1,
           questionLength: questions[currentLevel].length,
           question: questions[currentLevel]
         };
}


function checkAnswer( answer )
{
  let currentPal = questions[currentLevel];
  let res = pal.getLongest( currentPal );

  if( ( currentPal.length - answer == res.length ) && answer != '' )
  {
    currentLevel++;
    return 'answerCorrect';
  }
  return 'answerWrong';
}


function restart()
{
  currentLevel = 0;
  return getCurrent();
}

module.exports.getCurrent   = getCurrent;
module.exports.checkAnswer  = checkAnswer;
module.exports.restart      = restart;
