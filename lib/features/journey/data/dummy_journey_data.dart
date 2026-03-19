import 'package:flutter/material.dart';
import 'models/journey_model.dart';

class DummyJourneyData {
  static List<JourneyStep> getImportSteps() {
    return [
      const JourneyStep(
        id: 1,
        title: 'Decide Product',
        description: 'Choose product with demand & margin. Avoid restricted/prohibited items.',
        icon: Icons.inventory_2_rounded,
        status: JourneyStepStatus.active,
        questions: [
          JourneyQuestion(
            id: 'import_cat',
            text: 'Which product category are you interested in importing?',
            options: [
              'Technology & Electronics',
              'Fashion & Accessories',
              'Home & Furniture',
              'Health & Beauty',
              'Toys & Baby Products',
              'Automotive & Parts',
              'Industrial Goods',
              'Other'
            ],
          ),
        ],
      ),
      const JourneyStep(
        id: 2,
        title: 'Market Research',
        description: 'Check demand (India market). Analyze competition & pricing.',
        icon: Icons.bar_chart_rounded,
        questions: [
          JourneyQuestion(
            id: 'import_research',
            text: 'Have you identified your target audience in India?',
            options: ['Yes, fully researched', 'Partially', 'Not yet started'],
          ),
        ],
      ),
      const JourneyStep(
        id: 3,
        title: 'Find Supplier',
        description: 'Platforms: Alibaba, IndiaMART, trade fairs. Verify supplier (reviews, samples).',
        icon: Icons.person_search_rounded,
        questions: [
          JourneyQuestion(
            id: 'import_supplier',
            text: 'Which platform are you using to find suppliers?',
            options: ['Alibaba', 'IndiaMART', 'Global Sources', 'Trade Fairs', 'Other'],
          ),
        ],
      ),
      const JourneyStep(
        id: 4,
        title: 'Get Import Export Code (IEC)',
        description: 'Apply via DGFT (mandatory for import/export in India).',
        icon: Icons.assignment_ind_rounded,
        questions: [
          JourneyQuestion(
            id: 'import_iec',
            text: 'Do you have a valid PAN card and a current bank account?',
            options: ['Yes, both ready', 'Only PAN card', 'None yet'],
          ),
        ],
      ),
      const JourneyStep(
        id: 5,
        title: 'Check Regulations',
        description: 'HS Code, Import duty, GST, restrictions.',
        icon: Icons.gavel_rounded,
        questions: [
          JourneyQuestion(
            id: 'import_reg',
            text: 'Do you know the 8-digit HS code for your product?',
            options: ['Yes', 'I need help finding it', 'What is an HS Code?'],
          ),
        ],
      ),
      const JourneyStep(
        id: 6,
        title: 'Place Order',
        description: 'Issue Purchase Order (PO). Make payment.',
        icon: Icons.shopping_cart_checkout_rounded,
        questions: [
          JourneyQuestion(
            id: 'import_order',
            text: 'How do you plan to pay your supplier?',
            options: ['Letter of Credit (LC)', 'Advance TT', 'PayPal/Credit Card', 'Escrow'],
          ),
        ],
      ),
      const JourneyStep(
        id: 7,
        title: 'Negotiate Deal',
        description: 'Finalize: Price (FOB/CIF), MOQ (minimum order), Payment terms (Advance / LC).',
        icon: Icons.handshake_rounded,
        questions: [
          JourneyQuestion(
            id: 'import_neg',
            text: 'What is your primary negotiation goal?',
            options: ['Lower Price', 'Better Quality', 'Faster Delivery', 'Lower MOQ'],
          ),
        ],
      ),
      const JourneyStep(
        id: 8,
        title: 'Shipping & Logistics',
        description: 'Choose shipping: Air (fast, costly), Sea (cheap, slow). Hire freight forwarder.',
        icon: Icons.local_shipping_rounded,
        questions: [
          JourneyQuestion(
            id: 'import_ship',
            text: 'Which mode of transport is best for your volume?',
            options: ['Air Freight', 'Sea (FCL)', 'Sea (LCL)', 'Courier/Express'],
          ),
        ],
      ),
      const JourneyStep(
        id: 9,
        title: 'Customs Clearance',
        description: 'Invoice, Packing list, Bill of lading.',
        icon: Icons.description_rounded,
        questions: [
          JourneyQuestion(
            id: 'import_customs',
            text: 'Have you hired a Customs House Agent (CHA)?',
            options: ['Yes', 'Looking for one', 'I will do it myself'],
          ),
        ],
      ),
      const JourneyStep(
        id: 10,
        title: 'Receive Goods',
        description: 'Delivery to warehouse. Check quality & quantity.',
        icon: Icons.receipt_long_rounded,
        questions: [
          JourneyQuestion(
            id: 'import_receive',
            text: 'Do you have a dedicated warehouse for storage?',
            options: ['Yes, owned/leased', 'Third-party logistics (3PL)', 'Not yet'],
          ),
        ],
      ),
      const JourneyStep(
        id: 11,
        title: 'Sell in Market',
        description: 'Online / offline / wholesale. Price for profit.',
        icon: Icons.storefront_rounded,
        questions: [
          JourneyQuestion(
            id: 'import_sell',
            text: 'What is your primary sales channel?',
            options: ['E-commerce (Amazon/Flipkart)', 'Wholesale Distribution', 'Retail Store', 'Direct Sales'],
          ),
        ],
      ),
    ];
  }

  static List<JourneyStep> getExportSteps() {
    return [
      const JourneyStep(
        id: 1,
        title: 'Market Analysis',
        description: 'Identify high-demand countries for your product. Analyze export statistics.',
        icon: Icons.public_rounded,
        status: JourneyStepStatus.active,
        questions: [
          JourneyQuestion(
            id: 'export_market',
            text: 'Which region are you targeting for your exports?',
            options: ['USA & Europe', 'Middle East', 'Africa', 'South East Asia', 'Australia'],
          ),
        ],
      ),
      const JourneyStep(
        id: 2,
        title: 'Product Selection',
        description: 'Select products with high export potential and incentives.',
        icon: Icons.checklist_rtl_rounded,
        questions: [
          JourneyQuestion(
            id: 'export_prod',
            text: 'Is your product eligible for MEIS/RoDTEP schemes?',
            options: ['Yes, verified', 'Checking eligibility', 'I dont know about these schemes'],
          ),
        ],
      ),
      const JourneyStep(
        id: 3,
        title: 'Business Registration',
        description: 'Register your firm (Proprietorship/LLP/Pvt Ltd). Open a current account.',
        icon: Icons.business_center_rounded,
        questions: [
          JourneyQuestion(
            id: 'export_biz',
            text: 'What is your business structure?',
            options: ['Proprietorship', 'Partnership/LLP', 'Private Limited', 'OPC'],
          ),
        ],
      ),
      const JourneyStep(
        id: 4,
        title: 'IEC Registration',
        description: 'Obtain Import Export Code from DGFT.',
        icon: Icons.assignment_turned_in_rounded,
        questions: [
          JourneyQuestion(
            id: 'export_iec',
            text: 'Have you registered on the DGFT portal?',
            options: ['Yes', 'Process started', 'Not yet'],
          ),
        ],
      ),
      const JourneyStep(
        id: 5,
        title: 'Find Buyers',
        description: 'Engage in B2B portals, trade fairs, and embassies to find global buyers.',
        icon: Icons.language_rounded,
        questions: [
          JourneyQuestion(
            id: 'export_buyers',
            text: 'What is your strategy for finding international buyers?',
            options: ['B2B Portals (Alibaba/Indiamart)', 'Trade Fairs', 'LinkedIn/Cold Email', 'Referrals'],
          ),
        ],
      ),
      const JourneyStep(
        id: 6,
        title: 'Pricing & Quotation',
        description: 'Prepare Performa Invoice with FOB/CIF pricing.',
        icon: Icons.request_quote_rounded,
        questions: [
          JourneyQuestion(
            id: 'export_price',
            text: 'Do you know how to calculate FOB/CIF prices?',
            options: ['Yes, I have a calculator', 'Partially', 'I need a template'],
          ),
        ],
      ),
      const JourneyStep(
        id: 7,
        title: 'Export Documentation',
        description: 'Prepare Commercial Invoice, Packing List, and Shipping Bill.',
        icon: Icons.description_rounded,
        questions: [
          JourneyQuestion(
            id: 'export_docs',
            text: 'Are you familiar with the Bill of Lading (B/L) process?',
            options: ['Yes', 'Somewhat', 'No, help me understand'],
          ),
        ],
      ),
      const JourneyStep(
        id: 8,
        title: 'Quality Inspection',
        description: 'Ensure products meet international standards. Get pre-shipment inspection.',
        icon: Icons.rule_folder_rounded,
        questions: [
          JourneyQuestion(
            id: 'export_quality',
            text: 'Will you use a third-party inspection agency like SGS?',
            options: ['Yes', 'Supplier self-inspection', 'Buyer will inspect'],
          ),
        ],
      ),
      const JourneyStep(
        id: 9,
        title: 'Shipping & Freight',
        description: 'Book containers. Choose Air or Sea freight.',
        icon: Icons.directions_boat_rounded,
        questions: [
          JourneyQuestion(
            id: 'export_ship',
            text: 'Have you finalized an Incoterm with your buyer?',
            options: ['FOB', 'CIF', 'EXW', 'DDP'],
          ),
        ],
      ),
      const JourneyStep(
        id: 10,
        title: 'Duty Drawbacks',
        description: 'Claim export incentives like RoDTEP/DBK from the government.',
        icon: Icons.monetization_on_rounded,
        questions: [
          JourneyQuestion(
            id: 'export_incentives',
            text: 'Have you registered for the AD Code at the port of export?',
            options: ['Yes', 'In progress', 'What is an AD Code?'],
          ),
        ],
      ),
      const JourneyStep(
        id: 11,
        title: 'Payment Receipt',
        description: 'Secure payments via LC (Letter of Credit) or Advance TT.',
        icon: Icons.payments_rounded,
        questions: [
          JourneyQuestion(
            id: 'export_payment',
            text: 'What is your preferred payment term?',
            options: ['100% Advance', 'LC at Sight', 'DA/DP', 'Credit'],
          ),
        ],
      ),
    ];
  }
}
