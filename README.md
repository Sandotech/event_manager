# Event Manager - Analyzing Event Registrations

## Description:

This Ruby project provides a comprehensive event management solution, including:

- **Registration Data Processing:** Reads attendee data from a CSV file (`event_attendees.csv`).
- **Legislator Lookup:** Retrieves legislators for a given ZIP code using the Google Civic Information API (requires a valid API key).
- **Thank-You Letter Generation:** Creates personalized thank-you letters for each attendee using an ERB template (`form_letter.erb`).
- **Time Analysis:** Analyzes registration times to identify the most common hours for registrations.

## Getting Started:

1. **Prerequisites:**
    - Ruby ([https://www.ruby-lang.org/en/](https://www.ruby-lang.org/en/))
    - Required Gems:
        - `csv` (for CSV file processing)
        - `google-apis-civicinfo_v2` (for legislator lookup)
        - `erb` (for template processing)
        - `time` (for time manipulation)
2. **Installation:**
    - Install the required gems using `gem install csv google-apis-civicinfo_v2 erb time`.
3. **Usage:**
    - Place your `event_attendees.csv` file and `form_letter.erb` template in the project directory.
    - Create a file named `secret.key` containing your Google Civic Information API key (obtain from [invalid URL removed]).
    - Run the script: `ruby event_manager.rb`.

**Output:**

- Thank-you letters are saved in the `output` directory as HTML files (`thanks_<id>.html`).
- The most common registration hours are printed to the console.

**Example `event_attendees.csv`:**

```csv
,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode
1,11/12/08 10:47,Allison,Nguyen,arannon@jumpstartlab.com,6154385000,3155 19th St NW,Washington,DC,20010
2,11/12/08 13:23,SArah,Hankins,pinalevitsky@jumpstartlab.com,414-520-5000,2022 15th Street NW,Washington,DC,20009
...
```

**Example `form_letter.erb`:**

```erb
<html>
<head>
  <meta charset='UTF-8'>
  <title>Thank You!</title>
</head>
<body>
  <h1>Thanks <%= name %></h1>
  <p>Thanks for coming to our conference.  We couldn't have done it without you!</p>

  <p>
    Political activism is at the heart of any democracy and your voice needs to be heard.
    Please consider reaching out to your following representatives:
  </p>
...
```

<footer>
Diego Santos
</br>
Backend developer
</footer>