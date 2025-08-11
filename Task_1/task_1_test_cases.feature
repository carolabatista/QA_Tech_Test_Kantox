Feature: Cashier System Discount Rules and Configuration

  My approach to the task was to first address the happy paths, with and without rules applied.
  Given the prices were hardcoded in the task, I changed them to variables for scalability, but I understand that, depending on the 
  type of feature being tested, this would not make sense (For example: a marketing campaign that does need to display X value)
  
  Given the nature of how the possible rules were presented, my mind took me to the fact that they could overlap, 
  since the description didn't mention if they were exclusive, so I added one test case for this, with (in this case) a vague
  solution for the assurance, since I wasn't informed which rule would take precedence.
  
  The location path for the files were also mentioned specifically, and I understand that this could be an easy test to catch 
  problems with new code - so I added multiple test cases on how the system should behave if the files have missing products,
  or missing rules that are expected.

  In more traditional edge cases, I added two test cases for extremes, low (zero) and high volume of addition, and how would the system perform
  it (this could be taken and expanded into both BE and FE perspective, about performance for high load and if the UX would behave well with multiple products)

  AI usage disclosure:
  I informally scoped this in an internal file and gave Perplexity a prompt to return me the TCs in Gherkin, the results are below:


  Scenario: Add products without any discounts applied
    Given the products.yml contains <PRODUCT_1> priced at <PRICE_1> and <PRODUCT_2> priced at <PRICE_2>
    And the rules.yml contains no discount rules
    When I add <QTY_1> <PRODUCT_1> and <QTY_2> <PRODUCT_2> to the cart
    Then the total price should be <EXPECTED_TOTAL>

  Scenario: Apply FreeRule: Buy one get one free on <PRODUCT_1>
    Given the products.yml includes <PRODUCT_1> priced at <PRICE_1>
    And the rules.yml has a FreeRule configured for <PRODUCT_1> ("buy 1 get 1 free")
    When I add <QTY_FREE> <PRODUCT_1> to the cart
    Then the total price should be <EXPECTED_FREE_TOTAL>

  Scenario: Apply ReducedPriceRule: <PRODUCT_3> discounted when buying more than <REDUCED_THRESHOLD>
    Given the products.yml includes <PRODUCT_3> priced at <PRICE_3>
    And the rules.yml has a ReducedPriceRule ("buy more than <REDUCED_THRESHOLD>, pay <REDUCED_PRICE> each") for <PRODUCT_3>
    When I add <QTY_REDUCED> <PRODUCT_3> to the cart
    Then the total price should be <EXPECTED_REDUCED_TOTAL>

  Scenario: Apply FractionPriceRule: <PRODUCT_4> discounted at <FRACTION_RATE>% price when buying more than <FRACTION_THRESHOLD>
    Given the products.yml includes <PRODUCT_4> priced at <PRICE_4>
    And the rules.yml has a FractionPriceRule ("buy more than <FRACTION_THRESHOLD>, pay <FRACTION_RATE>% of price") for <PRODUCT_4>
    When I add <QTY_FRACTION> <PRODUCT_4> to the cart
    Then the total price should be <EXPECTED_FRACTION_TOTAL>

  Scenario: Handle missing or malformed products.yml file gracefully
    Given the products.yml file is missing or malformed
    When I start the cashier system
    Then the system should raise a clear error and not proceed with calculations

  Scenario: Handle missing or malformed rules.yml file gracefully
    Given the rules.yml file is missing or malformed
    When I start the cashier system
    Then the system should raise a clear error and not apply any discounts

  Scenario: Load products and rules from custom configuration paths
    Given product and rules YAML files are loaded from non-default paths
    And both YAML files are valid
    When I start the cashier system
    Then it should correctly load and apply products and discount rules from the specified locations

  Scenario: Conflict scenario: Multiple discount rules applied simultaneously for the same product
    Given the rules.yml configures both FreeRule and ReducedPriceRule for <PRODUCT_1>
    When I add <QTY_CONFLICT> <PRODUCT_1> to the cart
    Then the system should apply discounts following a clearly defined precedence or business logic

  Scenario: Exploratory: Add a product with zero quantity
    Given the products.yml includes <PRODUCT_1> priced at <PRICE_1>
    When I add 0 <PRODUCT_1> to the cart
    Then the total price should be 0.00

  Scenario: Exploratory: Add a product with very high quantity to test performance and rollover
    Given the products.yml includes <PRODUCT_3> priced at <PRICE_3>
    When I add <QTY_HIGH> <PRODUCT_3> to the cart
    Then the system should calculate the total price correctly with applicable discounts without errors
