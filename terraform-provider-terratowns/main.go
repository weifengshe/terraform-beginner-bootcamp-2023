package main
// package main: Declares the package name.
// The main package is special in Go, it's where the execution of the program starts.

// fmt is short format, it contains functions for formatted I/O
import (
	"context"
	"log"
	"fmt"
	"github.com/google/uuid"
	"github.com/hashicorp/terraform-plugin-sdk/v2/diag"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)


//func main(): Defines the main function, the entry point of the app
// when you run the program, it starts executing from this function
func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider,
	})
// Format print line
// prints to standard output 
	fmt.Println("Hello World!")

}

type Config struct {
	Endpoint string
	Token string
	UserUuid string  
}

// in golang, a titlecase function will get exported 

func Provider() *schema.Provider {
	var p *schema.Provider
	p = &schema.Provider{
		ResourcesMap: map[string]*schema.Resource{
			// "terratowns_home": Resource(),
		},
		DataSourcesMap: map[string]*schema.Resource{

		},
		Schema: map[string]*schema.Schema{
			"endpoint": {
				Type: schema.TypeString,
				Required: true,
				Description: "The endpoint for the external service",
			},
			"token": {
				Type: schema.TypeString,
				Sensitive: true, // make the token as sensitive to hide in the logs
				Required: true, 
				Description: "Bearer token for autorization",
			},
			"user_uuid": {
				Type: schema.TypeString,
				Required: true,
				Description: "UUID for configuration",
				ValidateFunc: validateUUID, 
			},
		},
	}
	p.ConfigureContextFunc = ProviderConfigure(p)
	return p 
} 
// := declare and assign at the same time
func validateUUID(v interface{}, k string) (ws []string, errors []error){
	log.Print("validateUUID: start")
	value := v.(string)
	if _, err := uuid.Parse(value); err != nil {
		errors = append(errors, fmt.Errorf("invalid UUID format"))
	}
	log.Print("validateUUID:end")
	return 
}


func ProviderConfigure(p *schema.Provider) schema.ConfigureContextFunc{
	return func(ctx context.Context, d *schema.ResourceData) (interface{}, diag.Diagnostics ){
		log.Print("providerConfigure:start")
		config := Config{
			Endpoint: d.Get("endpoint").(string),
			Token: d.Get("token").(string),
			UserUuid: d.Get("user_uuid").(string),
		}
		log.Print("providerConfigure:end")
		return &config, nil 
	}
}

func Resource() *schema.Resource{
	log.Print("Resource:start")
	resource := &schema.Resource{
		CreateContext: resourceHouseCreate,
		ReadContext: resourceHouseRead,
		UpdateContext: resourceHouseUpdate,
		DeleteContext: resourceHouseDelete,
	// 	Schema: map[string]*schema.Schema{
	// 		"name": {
	// 			Type: schema.TypeString,
	// 			Required: true,
	// 			Description: "Name of home",
	// 		},
	// 		"Description": {
	// 			Type: schema.TypeString,
	// 			Required: true,
	// 			Description: "Description of home",
	// 		},
	// 		"Domain_name": {
	// 			Type: schema.TypeString,
	// 			Required: true,
	// 			Description: "Domain name of home, eg. *.cloudfront.net",
	// 		},
	// 		"town": {
	// 			Type: schema.TypeString,
	// 			Required: true,
	// 			Description: "The town to which the home willl belong to",
	// 		},
	// 		"content_version": {
	// 			Type: schema.TypeString,
	// 			Required: true,
	// 			Description: "Then content version of the home",
	// 		},

	// 	},
	}
	log.Print("Resource:start")
	return resource
}

func resourceHouseCreate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics{
	var diags diag.Diagnostics
	return diags 
}

func resourceHouseRead(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics{
	var diags diag.Diagnostics
	return diags 
}

func resourceHouseUpdate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics{
	var diags diag.Diagnostics
	return diags 
}

func resourceHouseDelete(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics{
	var diags diag.Diagnostics
	return diags 
}