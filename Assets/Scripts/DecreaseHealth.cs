using UnityEngine;
using Unity.VisualScripting;

public class DecreaseHealth : MonoBehaviour
{
    public Material health; // Get reference to material
    private float damage = 1;

    void Update()
    {
        Increase();

        Decrease();
    }

    private void Decrease()
    {
        damage -= 0.25f * Time.deltaTime; // Reduce value of health

        health.SetFloat("_Health", damage);
    }

    private void Increase()
    {
        if (health.GetFloat("_Health") <= 0.1f) // Once health reaches zero reset it back to 1
        {
            health.SetFloat("_Health", 1f);

            damage = 1f;
        }
    }
}
