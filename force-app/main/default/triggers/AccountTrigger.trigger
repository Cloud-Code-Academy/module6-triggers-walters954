/*
AccountTrigger Overview

This trigger performs several operations on the Account object during its insertion. Depending on the values and conditions of the newly created Account, this trigger can:

1. Set the account's type to 'Prospect' if it's not already set.
2. Copy the shipping address of the account to its billing address.
3. Assign a rating of 'Hot' to the account if it has Phone, Website, and Fax filled.
4. Create a default contact related to the account after it's inserted.

Usage Instructions:
For this lesson, students have two options:
1. Use the provided `AccountTrigger` class as is.
2. Use the `AccountTrigger` from you created in previous lessons. If opting for this, students should:
    a. Copy over the code from the previous lesson's `AccountTrigger` into this file.
    b. Save and deploy the updated file into their Salesforce org.

Let's dive into the specifics of each operation:
*/
trigger AccountTrigger on Account(before insert, after insert) {
	// System.debug('AccountTrigger');
	// before insert
	// default type to prospect if there is no value
	if (Trigger.isBefore && Trigger.isInsert) {
		for (Account acc : Trigger.new) {
			if (acc.Type == null) {
				acc.Type = 'Prospect';
			}
		}
	}

	// before insert
	// when account is created automatically set shipping information into billing information
	// if there is no shipping information then set billing information to null
	if (Trigger.isBefore && Trigger.isInsert) {
		for (Account acc : Trigger.new) {
			if (acc.ShippingStreet != null) {
				acc.BillingStreet = acc.ShippingStreet;
			}

			if (acc.ShippingCity != null) {
				acc.BillingCity = acc.ShippingCity;
			}

			if (acc.ShippingState != null) {
				acc.BillingState = acc.ShippingState;
			}

			if (acc.ShippingPostalCode != null) {
				acc.BillingPostalCode = acc.ShippingPostalCode;
			}

			if (acc.ShippingCountry != null) {
				acc.BillingCountry = acc.ShippingCountry;
			}
		}
	}

	// if account has phone, website, and fax the prospect rating is hot
	if (Trigger.isBefore && Trigger.isInsert) {
		for (Account acc : Trigger.new) {
			if (acc.Phone != null && acc.Website != null && acc.Fax != null) {
				acc.Rating = 'Hot';
			}
		}
	}

	List<Contact> contacts = new List<Contact>();

	//after insert Write a trigger that executes after an Account is inserted.
	//The trigger should create a new Contact related to that Account with the LastName field set to 'DefaultContact' and the email set to 'default@email.com'.
	if (Trigger.isAfter && Trigger.isInsert) {
		for (Account acc : Trigger.new) {
			Contact con = new Contact();
			con.LastName = 'DefaultContact';
			con.Email = 'default@email.com';
			con.AccountId = acc.Id;
			contacts.add(con);
		}
		insert contacts;
	}

}
