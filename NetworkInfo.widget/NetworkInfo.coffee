# Execute the shell command.
command: "NetworkInfo.widget/NetworkInfo.sh"

# Set the refresh frequency (milliseconds).
refreshFrequency: 5000

# Render the output.
render: (output) -> """
  <table id='services'></table>
"""

# Update the rendered output.
update: (output, domEl) ->
  dom = $(domEl)

  # Parse the JSON created by the shell script.
  data = JSON.parse output
  html = ""

  # Loop through the services in the JSON.
  for svc in data.service

    # Start building our table cell.
    html += "<td class='service'>"

    # If there is an IP Address, we should show the connected icon. Otherwise we show the disable icon.
    # If there is no IP Address, we show "Not Connected" rather than the missing IP Address.
    if svc.ipaddress == ''
      html += "  <img class='icon' src='NetworkInfo.widget/images/" + svc.name + "_disabled.png'/>"
      html += "  <p class='primaryInfo'>Not Connected</p>"
    else
      html += "  <img class='icon' src='NetworkInfo.widget/images/" + svc.name + ".png'/>"
      html += "  <p class='primaryInfo'>" + svc.ipaddress + "</p>"

    # Show the Mac Address.
    if svc.macaddress && svc.macaddress != '(null)'
      html += "  <p class='secondaryInfo'>" + svc.macaddress + "</p>"

    # Show the SSID, if applicable
    if svc.ssid != ''
      html += "  <p class='secondaryInfo'>" + svc.ssid + "</p>"

    html += "</td>"

  # Set our output.
  $(services).html(html)

# CSS Style
style: """
  margin: 0
  padding: 0px
  right: 170px
  bottom: 20px
  color: #fff

  .service
    text-align:center
    padding:2px

  .icon
    height:32px
    width:32px

  .primaryInfo, .secondaryInfo
    font-family: Helvetica Neue
    padding:0px
    margin:2px

  .primaryInfo
    font-size:10pt
    font-weight:bold
    color: rgba(#fff,0.75)

  .secondaryInfo
    font-size:8pt
    color: rgba(#fff, 0.5)
"""
