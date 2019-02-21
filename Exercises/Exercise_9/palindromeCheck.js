//
//  Exercise 9: Scripting languages
//  Part 1: Server side scripting
//  Programming Languages 2
//  Michael Beyer
//

/*
function getLongest( str )
{
  var arr = str.split("");
  var endArr = [];

  for(var i = 0; i < arr.length; i++)
  {
    var temp = "";
    temp = arr[i];
    for(var j = i + 1; j < arr.length; j++)
    {
      temp += arr[j];
      if(temp.length > 2 && temp === temp.split("").reverse().join(""))
      {
        endArr.push(temp);
      }
    }
  }

  var count = 0;
  var longestPalindrome = "";
  for(var i = 0; i < endArr.length; i++)
  {
    if(count >= endArr[i].length)
    {
      longestPalindrome = endArr[i-1];
    }
    else
    {
      count = endArr[i].length;
    }
  }
  console.log(endArr);
  console.log(longestPalindrome);
  return longestPalindrome;
}
*/

function getLongest( string )
{
  var length = string.length;
  var result = "";

  var centeredPalindrome = function(left, right)
  {
    while (left >= 0 && right < length && string[left] === string[right]) {
      //expand in each direction.
      left--;
      right++;
    }

    return string.slice(left + 1, right);
  };

  for (var i = 0; i < length - 1; i++)
  {
    var oddPal = centeredPalindrome(i, i + 1);

    var evenPal = centeredPalindrome(i, i);

    if (oddPal.length > 1)
      console.log("oddPal: " + oddPal);
    if (evenPal.length > 1)
      console.log("evenPal: " + evenPal);

    if (oddPal.length > result.length)
      result = oddPal;
    if (evenPal.length > result.length)
      result = evenPal;
  }
  return result;
}

module.exports.getLongest = getLongest;
