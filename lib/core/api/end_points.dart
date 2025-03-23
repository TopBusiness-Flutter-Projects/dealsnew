import 'package:top_sale/core/utils/app_strings.dart';

class EndPoints {
  //static const String baseUrl = "https://demo17.topbuziness.com";
  // static String baseUrl =  AppStrings.demoBaseUrl;
  // static String db = "demo17.topbuziness.com";

  ///
  static String auth = "/auth/";
  static String resUsers = "/api/res.users/";
  static String checkEmployee = '/api/hr.employee/';
  static String fleetLogs = '/api/fleet.vehicle.logs/';
    static String createTask = '/api/project/task/create';

  static String allCategoriesUrl =
      '/api/product.category?query={id,name,image}&filter=[["is_active", "=","true"]]';
  static String allProducts = '/api/product.product/';
  static String products = '/api/product/all_paginated';
  static String productSearch = '/api/product/search';
  static String getAllPricelists = '/api/pricelist/all';
  static String getUserData = '/api/res.users/';
  static String getAllPartners = '/api/res.partner/';
  static String saleOrder = '/api/sale.order/';
  static String createPartner = '/api/partner/';
  static String partners = '/api/partners/';
  static String resPartner = '/api/res.partner/';
  static String objectSaleOrder = '/object/sale.order/';
  static String picking = '/api/picking/';
  static String createInvoice = '/api/sale_order/';
  static String returnOrder = '/return_picking/';
  static String invoice = '/api/invoice/';
  static String returnedOrder = '/api/sale_orders/returned';
  static String createQuotation = '/api/quotation/';
  static String createPicking = '/api/create_stock_picking';
  static String getPicking = '/api/get_pickings_by_employee_or_user';
  static String updateQuotation = '/api/quotation/update/';
  static String getAllJournals =
      '/api/account.journal/?query={id, display_name}';
  static String getAllShipping =
      '/api/shipping_methods/';
  static String getAllPromotions =
      '/api/active-promotions/';
  static String updateState = "/api/project/task/update_state";

  static String printOrder = '/report/pdf/sale.report_saleorder/';
  static String printPicking = '/report/pdf/stock.report_picking/';
  static String printPayment = '/report/pdf/account.report_payment_receipt/';
  static String printPosPayment = '/report/pdf/top_rest_api.top_payment_receipt/';
  static String printInvoice =
      '/report/pdf/account.report_invoice_with_payments/';
  static String printposInvoice =
      '/report/pdf/top_rest_api.receipt_invoice/';
  static String printPaySlip = '/report/pdf/hr_payroll.report_payslip_lang/';
  static String wareHouse = '/api/stock.warehouse/';
  static String createPayment = '/api/payment/create';
  /////////// HR/////////
  static String employee = '/api/employee/';
  static String expense = '/api/expense/products';
  static String updatePartnerLocation = '/api/res.partner';
  static String getTasks = '/api/project/tasks/by_user';

  ///////
  // static String authWithSession = "$baseUrl/web/session/authenticate";

  // static String authWithSession = "$baseUrl/web/session/authenticate";
  // static String allCategoryProducts = '$baseUrl/api/product.product/';
  // static String getUsers =
  //     '$baseUrl/api/res.partner?query={name,mobile,id, city,street,phone,is_company}';
  // static String getAllPartners = '$baseUrl/api/res.partner?';
  // // '$baseUrl/api/res.partner?query={name,id, phone,total_overdue,total_due,total_invoiced,sale_order_ids,credit_to_invoice}';
  // static String getUserData =
  //     '$baseUrl/api/res.users/?query={id, name,partner_id,image_1920,login}';
  // static String getEmployeeId = '$baseUrl/api/res.users/';
  // static String addPartner = '$baseUrl/api/res.partner/';
  // static String newLead = '$baseUrl/api/crm.lead/';
  // static String companyData = '$baseUrl/api/res.company/?';
  // static String currencyName = '$baseUrl/api/res.currency/?';
  // static String createPicking = '$baseUrl/api/stock.picking/';
  // static String objectAccountMove = '$baseUrl/object/account.move/';
  // static String createStokeMove = '$baseUrl/api/stock.move';
  // static String getTaxes =
  //     '$baseUrl/api/account.tax/?query={id, display_name}&';
  // static String fromLocation =
  //     '$baseUrl/api/stock.location/?query={id,name}&filter=[["usage", "=", "internal"]]';
  // static String toLocation =
  //     '$baseUrl//api/stock.location/?query={id,name}&filter=[["usage", "=", "internal"]]';

  // static String saleOrder = '$baseUrl/api/sale.order/';
  // static String stockPicking = '$baseUrl/api/stock.picking/';
  // static String stockPickingObject = '$baseUrl/object/stock.picking/';
  // static String workFlow = '$baseUrl/api/sh.auto.sale.workflow/';
  //  static String wareHouse = '$baseUrl/api/stock.warehouse/';
  // static String saleOrderLine = '$baseUrl/api/sale.order.line';
  // static String getSaleOrder = '$baseUrl/api/sale.order/';
  // static String createPayment = '$baseUrl/api/account.payment/';
  // static String createPayment2 = '$baseUrl/api/account.move/';
  // static String confirmPayment = '$baseUrl/object/account.payment/';
  // static String createInvoice = '$baseUrl/api/account.move/';
  // static String invoiceLine = '$baseUrl/api/account.move.line';
  // static String getAllJournals =
  //     '$baseUrl/api/account.journal/?query={id, display_name}';
  // static String getAllJournalName = '$baseUrl/api/account.journal/';
}
