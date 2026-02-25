using UnityEngine;

public class Movement : MonoBehaviour
{
    public Transform cam;
    public Rigidbody rb;
    public float speed;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }
    void Update()
    {
        Vector3 movement = cam.right * Input.GetAxisRaw("Horizontal");

        rb.AddForce(movement * speed);
    }
}
