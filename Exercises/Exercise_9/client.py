#
#  Exercise 9: Scripting languages
#  Part 2: Client side scripting
#  Programming Languages 2
#  Michael Beyer
#

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options

serverAddress = "https://courses.softlab.ntua.gr/pl2/2018b/exercises/palseq.php"
serverAddress2 = "http://localhost:3000/pl2/longestPal"


def longestPalSubstr(string):
    maxLength = 1

    start = 0
    length = len(string)

    low = 0
    high = 0

    # One by one consider every character as center point of
    # even and length palindromes
    for i in xrange(1, length):
        # Find the longest even length palindrome with center
    # points as i-1 and i.
        low = i - 1
        high = i
        while low >= 0 and high < length and string[low] == string[high]:
            if high - low + 1 > maxLength:
                start = low
                maxLength = high - low + 1
            low -= 1
            high += 1

        # Find the longest odd length palindrome with center
        # point as i
        low = i - 1
        high = i + 1
        while low >= 0 and high < length and string[low] == string[high]:
            if high - low + 1 > maxLength:
                start = low
                maxLength = high - low + 1
            low -= 1
            high += 1

    #print "Longest palindrome substring is:",
    #print string[start:start + maxLength]

    return maxLength


def play():
    currentRound = driver.find_element_by_xpath( "//code[@id='question']/.." )
    currentQuestion = driver.find_element_by_id( "question" )

    res = longestPalSubstr( currentQuestion.text )

    print("{0}".format( currentRound.text.replace( '\n', ', ' ) ) )
    print("Answer: {0}".format( len(currentQuestion.text) - res ) )

    form = driver.find_element_by_id( "answer" )
    form.send_keys( str(len(currentQuestion.text) - res ) + Keys.RETURN )

    print(driver.find_element_by_xpath( "//p[@class]" ).text)


# Setup
chrome_options = Options()
chrome_options.add_argument("--headless")

driver = webdriver.Chrome( chrome_options=chrome_options )
driver.get( serverAddress )

count = 0
while count < 10:
    play()

    # check for next round
    if( len( driver.find_elements_by_id( "again" ) ) != 0 ):
        driver.find_element_by_id( "again" ).click()
    else:
        print( "Could't find 'again' button. Exiting..." )
        break

    count += 1

driver.close();
