describe('FAQ Dropdown', () => {
  it('toggles FAQ answer and chevron on click', () => {
    cy.visit('http://localhost:3000/contact');
    cy.contains('Frequently Asked Questions').should('exist');

    // Find the first FAQ button and answer
    cy.get('[data-controller="faq"] button').first().as('faqButton');
    cy.get('[data-controller="faq"] [data-faq-target="answer"]').first().as('faqAnswer');

    // Initially hidden
    cy.get('@faqAnswer').should('have.class', 'hidden');

    // Click to show
    cy.get('@faqButton').click();
    cy.get('@faqAnswer').should('not.have.class', 'hidden');
    cy.get('@faqButton').find('svg').should('have.class', 'rotate-180');

    // Click again to hide
    cy.get('@faqButton').click();
    cy.get('@faqAnswer').should('have.class', 'hidden');
    cy.get('@faqButton').find('svg').should('not.have.class', 'rotate-180');
  });
});
