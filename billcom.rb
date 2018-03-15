
# initiate session requires seleinum webdriver and chrome driver installed on box.
require 'selenium-webdriver'
require 'csv'

browser = 'Selenium::WebDriver.for(:chrome)'
browser.get('http://www.bill.com')
loginbutton = browser.find_element(:class, 'btn-t10login')
loginbutton.click
# wait for load
email = browser.find_element(:id, 'email')
email.send_keys('mark@verdigris.co')
password = browser.find_element(:id, 'password')
password.send_keys('silverchair74')
password.submit

# retrieve report
startDate = 'dateoflastrun'
endDate = 'Today'

browser.get('https://app.bill.com/BaseJReportServlet?corgcId=00801OLSMGHHLDWTwfdi&dateRange=custom&startDate=01%2F01%2F16&endDate=05%2F14%2F17&groupBy=date&format=CSV&report=MoneyMovementDetails&submitValue=null');

DOWNLOAD_DIR_BROWSERENV/filename.csv
Process-report()

payments = []
transfers = []
transfer = []
arr_arrs = CSV.read("/Users/mychung/Downloads/rpt0810210643.csv")
arr_arrs.each do |lines|
   cleanlines=lines.reject{ |cell| cell == nil }
   if cleanlines.size==7 #standard withdrawaltransaction
     payments.push cleanlines
   elsif cleanlines.size==2
     if cleanlines.include? "Subtotal:"
       transfer = transfer+cleanlines
       transfers.push transfer
       transfer=[]
     elsif cleanlines.include? "PROCESS DATE"
       transfer = cleanlines
     end
   end
end

CSV.open("New Statement.csv", "wb") do |csv|
  csv << ["*Date", "*Amount", "Payee", "Description", "Reference","Check Number"]
  payments.each do |payment|
    payment[4] = "-" + payment[4]
    csv << [payment[3], payment[4], payment[0], payment[0], payment[2], payment[1]]
  end
  transfers.each do |item|
    csv << [item[0], item[3], "Chase Checking", "Transfer from Chase"]
  end
end


# API_URL_EndPoint
#  stagingEndPoint = https://api-stage.bill.com/api/v2/
#  productionEndPoint = https://api.bill.com/api/v2/
#  myUser = "mark@verdigris.co"
#  myPassword ="silverchair74"
#  myOrgId="00801OLSMGHHLDWTwfdi"
#  myDevKey=" "
#
# 1. Initiate Session -Login API
#
# LoginRequest:
#   stagingEndPoint."Login.json"?userName=myUser&password=myPassword&orgId=myOrgId&devKey=myDevKey
#
#
# sandbox - https://app-stage.bill.com/Login
#   UserID
#   OrganizationID -
#
#   developer key
#   use credentials.
#
# https://app.bill.com/OrgSelect?orgId=00801OLSMGHHLDWTwfdi
#   devKey
#   sessionId
#   data
#
#   (session ID, and endpoint URL)
#   data={
#      "id" : "mmt01YRBUVNFAOZETFxr"
#   }
#
#
# 2. API file request
#
# <API_URL_EndPoint>/Crud/Read/MoneyMovement.json
#
# https://app.bill.com/BaseJReportServlet?corgcId=00801OLSMGHHLDWTwfdi&dateRange=custom&startDate=01%2F01%2F16&endDate=05%2F14%2F17&groupBy=date&format=CSV&report=MoneyMovementDetails&submitValue=null
#
# https://app.bill.com/BaseJReportServlet?corgcId=00801OLSMGHHLDWTwfdi&dateRange=custom&startDate=01%2F01%2F16&endDate=05%2F14%2F17&groupBy=date&format=HTML&report=MoneyMovementDetails&submitValue=null
#
#
# 3. logout session.
