﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace mvcComputersCompany
{
    public partial class frmConsultarPortatiles : Form
    {
        public frmConsultarPortatiles()
        {
            InitializeComponent();
        }
        private void btnFinalizar_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
